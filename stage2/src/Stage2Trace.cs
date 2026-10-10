// Stage 2 observation/replay entry. The official RSG body is unchanged.
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using Microsoft.Boogie;
using Microsoft.Boogie.SMTLib;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Microsoft.Basetypes;
using VC;
namespace Microsoft.Boogie.Houdini {
 public partial class MLHoudini {
  private static object S2Ast(Expr e) {
   var lit=e as LiteralExpr;
   if(lit!=null) return new {kind="literal",value=lit.ToString(),sort=lit.Type.ToString()};
   var id=e as IdentifierExpr;
   if(id!=null) return new {kind="identifier",name=id.Name,sort=id.Decl.TypedIdent.Type.ToString()};
   var n=e as NAryExpr;
   if(n!=null) return new {kind="application",op=n.Fun.FunctionName,args=n.Args.Select(S2Ast).ToArray(),sort=e.Type==null?null:e.Type.ToString()};
   return new {kind="unsupported",boogie=e.ToString(),type=e.GetType().ToString()};
  }
  private static List<Expr> S2Flatten(Expr e,string op) {
   var n=e as NAryExpr;
   if(n!=null && n.Fun.FunctionName==op) return n.Args.SelectMany(a=>S2Flatten(a,op)).ToList();
   return new List<Expr>{e};
  }
  private Expr S2Run(Expr input) {
   string dir=Environment.GetEnvironmentVariable("RSG_STAGE2_DIR");
   if(String.IsNullOrEmpty(dir)) return modifiedGeneralizeRS_2(input);
   Directory.CreateDirectory(dir);
   var solver=prover as SMTLibProcessTheoremProver;
   int checks=solver.Stage2Checks,cores=solver.Stage2Cores;double seconds=solver.Stage2Seconds;
   var watch=Stopwatch.StartNew();
   Expr output=modifiedGeneralizeRS_2(input);
   watch.Stop();
   var rec=new Dictionary<string,object>();
   try {
   rec["input_ast"]=S2Ast(input);rec["output_ast"]=S2Ast(output);
   rec["input_boogie"]=input.ToString();rec["output_boogie"]=output.ToString();
   rec["dnf"]=S2Flatten(input,"||").Select(t=>S2Flatten(t,"&&").Select(S2Ast).ToArray()).ToArray();
   rec["variables"]=existentialFunctions["b1"].InParams.Select(v=>new {name=v.Name,sort=v.TypedIdent.Type.ToString()}).ToArray();
   rec["attributes"]=attribute2Expr["b1"].Values.Select(S2Ast).ToArray();
   rec["distances"]=boundForRSGeneralization;
   rec["smt_calls"]=solver.Stage2Checks-checks;rec["core_calls"]=solver.Stage2Cores-cores;
   rec["solver_seconds"]=solver.Stage2Seconds-seconds;rec["rsg_seconds"]=watch.Elapsed.TotalSeconds;
   rec["pid"]=Process.GetCurrentProcess().Id;rec["source_file"]=filename;
   try { S2ExportContext(rec,solver); } catch(Exception e) {rec["context_error"]=e.ToString();solver.Stage2CaptureOnly=false;}
   } catch(Exception e) {rec["trace_error"]=e.ToString(); solver.Stage2CaptureOnly=false;}
   File.WriteAllText(Path.Combine(dir,"trace.json"),JsonConvert.SerializeObject(rec,Formatting.Indented));
   Console.WriteLine("[STAGE2_TRACE] "+Path.Combine(dir,"trace.json"));
   return output;
  }
  private void S2ExportContext(Dictionary<string,object> rec,SMTLibProcessTheoremProver solver) {
   string impl=implWithRS.Name;impl=impl.Substring(0,impl.Length-"_instrumented".Length);
   var pars=new List<Variable>(existentialFunctions["b1"].InParams);
   var candidate=new Function(Token.NoToken,"Stage2Candidate",pars,
       new Formal(Token.NoToken,new TypedIdent(Token.NoToken,"r",Microsoft.Boogie.Type.Bool),false));
   var terms=new List<Expr>();var bindings=new List<object>();
   foreach(var tup in impl2FuncCalls[impl]) {
    var control=tup.Item2;var actual=tup.Item3.Args.ToList();
    var formal=control.InParams.Select(v=>(Expr)Expr.Ident(v)).ToList();
    Expr rhs=new NAryExpr(Token.NoToken,new FunctionCall(candidate),actual);
    Expr lhs=new NAryExpr(Token.NoToken,new FunctionCall(control),formal);
    Expr binding=Expr.Eq(lhs,rhs);
    if(control.InParams.Count!=0) binding=new ForallExpr(Token.NoToken,new List<Variable>(control.InParams),new Trigger(Token.NoToken,true,new List<Expr>{lhs}),binding);
    terms.Add(binding);bindings.Add(new {control=control.Name,args=actual.Select(S2Ast).ToArray(),arity=control.InParams.Count});
   }
   foreach(var p in extraFunc2Value) {
    var f=new Function(Token.NoToken,p.Key,new List<Variable>(),new Formal(Token.NoToken,new TypedIdent(Token.NoToken,"r",Microsoft.Boogie.Type.Bool),false));
    terms.Add(Expr.Eq(new NAryExpr(Token.NoToken,new FunctionCall(f),new List<Expr>()),p.Value));
   }
   rec["context_bindings"]=bindings;rec["context_kind"]="official impl2VC with symbolic recurrent predicate; no additional check-sat";
   var env=BinaryTreeAnd(terms,0,terms.Count-1);env.Typecheck(new TypecheckingContext((IErrorSink)null));
   var gen=prover.VCExprGen;
   var vc=gen.Implies(prover.Context.BoogieExprTranslator.Translate(env),impl2VC[impl]);
   // Record-only transaction: Send() omits Process.Send while capturing, so the
   // live solver receives no assertions, declarations, pushes or queries here.
   solver.Stage2CaptureOnly=true;solver.Stage2Mark("CONTEXT_BEGIN");
   prover.Push();prover.Assert(gen.Not(vc),true);prover.FlushAxiomsToTheoremProver();
   solver.Stage2Mark("CONTEXT_SNAPSHOT");prover.Pop();solver.Stage2Mark("CONTEXT_END");
   solver.Stage2CaptureOnly=false;
  }
  private Expr S2ReadAst(JToken a,Dictionary<string,Variable> vars) {
   string kind=(string)a["kind"];
   if(kind=="identifier") return Expr.Ident(vars[(string)a["name"]]);
   if(kind=="literal") {
    if((string)a["sort"]=="bool") return Expr.Literal((string)a["value"]=="true");
    if((string)a["sort"]=="int") return Expr.Literal(BigNum.FromString((string)a["value"]));
    throw new NotSupportedException("Replay literal sort "+a["sort"]);
   }
   var xs=a["args"].Select(x=>S2ReadAst(x,vars)).ToList();string op=(string)a["op"];
   if(xs.Count==1) return Expr.Unary(Token.NoToken,op=="!"?UnaryOperator.Opcode.Not:UnaryOperator.Opcode.Neg,xs[0]);
   var ops=new Dictionary<string,BinaryOperator.Opcode>{{"&&",BinaryOperator.Opcode.And},{"||",BinaryOperator.Opcode.Or},{"==>",BinaryOperator.Opcode.Imp},{"<==>",BinaryOperator.Opcode.Iff},{"+",BinaryOperator.Opcode.Add},{"-",BinaryOperator.Opcode.Sub},{"*",BinaryOperator.Opcode.Mul},{"<=",BinaryOperator.Opcode.Le},{"<",BinaryOperator.Opcode.Lt},{">=",BinaryOperator.Opcode.Ge},{">",BinaryOperator.Opcode.Gt},{"==",BinaryOperator.Opcode.Eq},{"!=",BinaryOperator.Opcode.Neq},{"div",BinaryOperator.Opcode.Div},{"mod",BinaryOperator.Opcode.Mod}};
   if(xs.Count!=2 || !ops.ContainsKey(op)) throw new NotSupportedException("Replay operation "+op);
   return Expr.Binary(Token.NoToken,ops[op],xs[0],xs[1]);
  }
  private VCGenOutcome S2Replay() {
   var vars=existentialFunctions["b1"].InParams.ToDictionary(v=>v.Name,v=>v);
   var body=S2ReadAst(JToken.Parse(File.ReadAllText(Environment.GetEnvironmentVariable("RSG_STAGE2_SEED_AST"))),vars);
   S2Run(body);
   return new VCGenOutcome(ProverInterface.Outcome.Valid,new List<Counterexample>());
  }
 }
}
