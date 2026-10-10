"""Offline checker using the actual captured official VC, unbounded SMT.
No loop transition is guessed from program names or the two-variable witness.
"""
import hashlib,json,pathlib,time,re
import z3
from common import S,dump

def commands(text):
 depth=0;start=None;quoted=False;string=False;comment=False;i=0
 while i<len(text):
  ch=text[i]
  if comment:
   if ch=='\n':comment=False
  elif quoted:
   if ch=='|':quoted=False
  elif string:
   if ch=='"':
    if i+1<len(text) and text[i+1]=='"':i+=1
    else:string=False
  elif ch==';':comment=True
  elif ch=='|':quoted=True
  elif ch=='"':string=True
  elif ch=='(':
   if depth==0:start=i
   depth+=1
  elif ch==')':
   depth-=1
   if depth==0 and start is not None:yield text[start:i+1];start=None
  i+=1
 if depth:raise ValueError('Unbalanced SMT stream')

def erase_annotations(command):
 # SMT-LIB annotations (! expression :key value ...) have the expression's value.
 # Z3 4.8.9's Python parser exposes legacy :lblpos/:lblneg as label AST nodes;
 # erase metadata structurally before independently solving the formula.
 tokens=re.findall(r'\|[^|]*\||"(?:[^"]|"")*"|[()]|[^\s()]+',command)
 pos=0
 def read():
  nonlocal pos
  t=tokens[pos];pos+=1
  if t!='(':return t
  children=[]
  while tokens[pos]!=')':children.append(read())
  pos+=1
  return children
 def render(node):
  if isinstance(node,str):return node
  if node and node[0]=='!':return render(node[1])
  return '('+' '.join(map(render,node))+')'
 node=read()
 if pos!=len(tokens):raise ValueError('SMT token remainder')
 return render(node)

def freeze_context(path):
 text=path.read_text();mark='; STAGE2_CONTEXT_SNAPSHOT'
 if mark not in text:raise ValueError('Missing complete context snapshot')
 prefix=text[:text.index(mark)];stack=[[]]
 for cmd in commands(prefix):
  head=cmd[1:].split(None,1)[0].rstrip(')')
  if head=='push':
   for _ in range(int(cmd[1:-1].split()[1]) if len(cmd[1:-1].split())>1 else 1):stack.append([])
  elif head=='pop':
   for _ in range(int(cmd[1:-1].split()[1]) if len(cmd[1:-1].split())>1 else 1):stack.pop()
  elif head=='reset':stack=[[]]
  elif head in ('declare-fun','declare-const','declare-sort','declare-datatypes','define-fun','define-sort','assert'):
   stack[-1].append(erase_annotations(cmd))
 return '\n'.join(c for frame in stack for c in frame)+'\n'

def sort(name):
 if name=='int':return z3.IntSort()
 if name=='bool':return z3.BoolSort()
 if name=='real':return z3.RealSort()
 raise ValueError('Unsupported sort '+name)

def from_ast(a,env):
 k=a['kind']
 if k=='identifier':return env[a['name']]
 if k=='literal':
  if a['sort']=='bool':return z3.BoolVal(a['value'].lower()=='true')
  return z3.RealVal(a['value']) if a['sort']=='real' else z3.IntVal(a['value'])
 if k!='application':raise ValueError('Unsupported AST '+str(a))
 xs=[from_ast(x,env) for x in a['args']];op=a['op']
 if op=='&&':return z3.And(xs)
 if op=='||':return z3.Or(xs)
 if op=='!':return z3.Not(xs[0])
 if op=='==>':return z3.Implies(*xs)
 if op=='<==>':return xs[0]==xs[1]
 if op=='-':return -xs[0] if len(xs)==1 else xs[0]-xs[1]
 if op=='+':return xs[0]+xs[1]
 if op=='*':return xs[0]*xs[1]
 if op in ('/','div'):return xs[0]/xs[1]
 if op in ('%','mod'):return xs[0]%xs[1]
 if op=='<=':return xs[0]<=xs[1]
 if op=='<':return xs[0]<xs[1]
 if op=='>=':return xs[0]>=xs[1]
 if op=='>':return xs[0]>xs[1]
 if op=='==':return xs[0]==xs[1]
 if op=='!=':return xs[0]!=xs[1]
 if op=='if-then-else':return z3.If(*xs)
 raise ValueError('Unsupported operator '+op)

def walk(e):
 yield e
 if z3.is_quantifier(e):yield from walk(e.body())
 else:
  for c in e.children():yield from walk(c)

class Context:
 def __init__(self,directory,log=None,timeout=2000):
  self.directory=pathlib.Path(directory);self.trace=json.loads((self.directory/'trace.json').read_text())
  self.env={v['name']:z3.Const(v['name'],sort(v['sort'])) for v in self.trace['variables']}
  self.vars=list(self.env.values());self.seed=from_ast(self.trace['input_ast'],self.env);self.official=from_ast(self.trace['output_ast'],self.env)
  self.terms=[z3.And([from_ast(a,self.env) for a in term]) for term in self.trace['dnf']]
  snapshot=freeze_context(self.directory/'prover.smt2')
  (self.directory/'context.smt2').write_text(snapshot)
  self.raw_bad=z3.And(list(z3.parse_smt2_string(snapshot)))
  fs={e.decl() for e in walk(self.raw_bad) if z3.is_app(e) and str(e.decl().name())=='Stage2Candidate'}
  if len(fs)!=1:raise ValueError('No unique candidate symbol')
  self.fun=next(iter(fs));self.queries=[];self.log=pathlib.Path(log) if log else None;self.timeout=timeout
  # The exporter defines each zero-arity control by the recorded predicate application.
  # Substitute exactly those definitions, preserving all other native constraints.
  consts={str(e.decl().name()):e for e in walk(self.raw_bad) if z3.is_const(e)}
  mapping=[]
  for binding in self.trace['context_bindings']:
   if binding['arity']!=0:raise ValueError('Parameterized control requires quantified replay')
   lhs=consts[binding['control']]
   args=[from_ast(a,consts) for a in binding['args']]
   mapping.append((lhs,self.fun(*args)))
  self.control_variables=[a for a,b in mapping]
  self.bad=z3.simplify(z3.substitute(self.raw_bad,*mapping))
  self.nnf=z3.Tactic('nnf')(self.bad).as_expr()
  self.apps={e.sexpr():e for e in walk(self.nnf) if z3.is_app(e) and e.decl()==self.fun}
  self.supports_polarity=not any(z3.is_quantifier(e) for e in walk(self.nnf))
 def check(self,name,formula,expected=None):
  s=z3.Solver();s.set(timeout=self.timeout,random_seed=0);s.add(formula)
  start=time.perf_counter();status=s.check();elapsed=time.perf_counter()-start
  row={'name':name,'result':str(status),'seconds':elapsed,'expected':expected,'passed':str(status)==expected if expected else None}
  if status==z3.sat:row['model']=str(s.model())
  if status==z3.unknown:row['reason']=s.reason_unknown()
  if self.log:
   self.log.mkdir(parents=True,exist_ok=True);f=self.log/f'{len(self.queries):05d}_{name}.smt2';f.write_text(s.to_smt2());row['query_file']=str(f.relative_to(S.parent))
  self.queries.append(row);return row,s.model() if status==z3.sat else None
 def apply_candidate(self,expr,r):
  apps={e.sexpr():e for e in walk(expr) if z3.is_app(e) and e.decl()==self.fun}
  replacements=[(e,z3.substitute(r,*list(zip(self.vars,e.children())))) for e in apps.values()]
  return z3.substitute(expr,*replacements)
 def instance(self,r):return self.apply_candidate(self.bad,r)
 def polarized(self,pre,post):
  if not self.supports_polarity:raise ValueError('Quantified polarity context unsupported')
  def body(r,e):return z3.substitute(r,*list(zip(self.vars,e.children())))
  def rec(e):
   if z3.is_app(e) and e.decl()==self.fun:return body(pre,e)
   if z3.is_not(e) and z3.is_app(e.arg(0)) and e.arg(0).decl()==self.fun:return z3.Not(body(post,e.arg(0)))
   if z3.is_and(e):return z3.And([rec(c) for c in e.children()])
   if z3.is_or(e):return z3.Or([rec(c) for c in e.children()])
   if any(z3.is_app(a) and a.decl()==self.fun for a in walk(e)):raise ValueError('Candidate occurs outside NNF literal')
   return e
  return rec(self.nnf)
 def validate(self,r,name='candidate'):
  a,_=self.check(name+'_seed',z3.And(self.seed,z3.Not(r)),'unsat')
  b,_=self.check(name+'_official_guard_closure',self.instance(r),'unsat')
  return {'valid':a['passed'] and b['passed'],'checks':[a,b]}
 def compare(self,a,b,name='sets'):
  x,_=self.check(name+'_A_not_B',z3.And(a,z3.Not(b)))
  y,_=self.check(name+'_B_not_A',z3.And(b,z3.Not(a)))
  statuses=(x['result'],y['result'])
  relation={('unsat','unsat'):'equal',('unsat','sat'):'B_strictly_larger',('sat','unsat'):'A_strictly_larger',('sat','sat'):'incomparable'}.get(statuses,'unknown')
  return {'relation':relation,'checks':[x,y]}
