"""Final-condition parser, including SymPy's integer abs output.
Separate from the frozen candidate/guard parser used by the offline baselines.
"""
import re,z3


def parse(text, env):
    tokens=re.findall(r'&&|\|\||<=|>=|==|!=|[(),+\-*/%<>!&|~]|\d+|[A-Za-z_][A-Za-z_0-9]*',text)
    if ''.join(tokens)!=re.sub(r'\s+','',text):raise ValueError('Unrecognized formula text: '+text)
    index=0
    prec={'||':1,'|':1,'&&':2,'&':2,'==':3,'!=':3,'<':3,'>':3,'<=':3,'>=':3,'+':4,'-':4,'*':5,'/':5,'%':5,'div':5,'mod':5}
    def expr(minimum=0):
        nonlocal index
        token=tokens[index];index+=1
        if token=='(':
            left=expr();assert tokens[index]==')';index+=1
        elif token.lower() in ('ne','eq'):
            assert tokens[index]=='(';index+=1
            a=expr();assert tokens[index]==',';index+=1
            b=expr();assert tokens[index]==')';index+=1
            left=a!=b if token.lower()=='ne' else a==b
        elif token.lower()=='abs':
            assert tokens[index]=='(';index+=1
            a=expr();assert tokens[index]==')';index+=1
            left=z3.If(a>=0,a,-a)
        elif token in ('-','!','~'):
            a=expr(6);left=-a if token=='-' else z3.Not(a)
        elif token.isdigit():left=z3.IntVal(int(token))
        elif token in env:left=env[token]
        elif token.lower() in ('true','false'):left=z3.BoolVal(token.lower()=='true')
        else:raise ValueError('Unexpected symbol '+token)
        while index<len(tokens) and tokens[index] in prec and prec[tokens[index]]>=minimum:
            op=tokens[index];index+=1;right=expr(prec[op]+1)
            if op in ('&&','&'):left=z3.And(left,right)
            elif op in ('||','|'):left=z3.Or(left,right)
            elif op=='==':left=left==right
            elif op=='!=':left=left!=right
            elif op=='<':left=left<right
            elif op=='>':left=left>right
            elif op=='<=':left=left<=right
            elif op=='>=':left=left>=right
            elif op=='+':left=left+right
            elif op=='-':left=left-right
            elif op=='*':left=left*right
            elif op in ('/','div'):left=left/right
            elif op in ('%','mod'):left=left%right
        return left
    result=expr();assert index==len(tokens),(tokens,index)
    return result
