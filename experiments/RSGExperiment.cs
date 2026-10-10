// Experimental entry and telemetry only. The official RSG method is unchanged.
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using Microsoft.Boogie;
using VC;

namespace Microsoft.Boogie.Houdini {
    public partial class MLHoudini {
        private bool RsgExperimentRequested() {
            if (!CommandLineOptions.Clo.RSInfer) return false;
            if (Environment.GetEnvironmentVariable("RSG_EXPERIMENT") == "direct") return true;
            string marker = Environment.GetEnvironmentVariable("RSG_INJECT_ONCE");
            return !String.IsNullOrEmpty(marker) && !File.Exists(marker);
        }

        private Expr RsgFixedSeed(bool oracle) {
            List<Variable> vs = existentialFunctions["b1"].InParams;
            if (vs.Count != 2 || vs[0].Name != "p" || vs[1].Name != "x")
                throw new InvalidOperationException("Experiment requires b1(p:int,x:int)");
            Expr p = Expr.Ident(vs[0]), x = Expr.Ident(vs[1]);
            Expr np = Expr.Unary(Token.NoToken, UnaryOperator.Opcode.Neg, p);
            Expr nx = Expr.Unary(Token.NoToken, UnaryOperator.Opcode.Neg, x);
            Expr a = Expr.And(Expr.And(Expr.Le(p,Expr.Literal(0)),Expr.Le(np,Expr.Literal(0))),
                             Expr.And(Expr.Le(x,Expr.Literal(oracle ? 1 : 0)),Expr.Le(nx,Expr.Literal(0))));
            Expr b = Expr.And(Expr.And(Expr.Le(p,Expr.Literal(1)),Expr.Le(np,Expr.Literal(-1))),
                             Expr.And(Expr.Le(x,Expr.Literal(4)),Expr.Le(nx,Expr.Literal(oracle ? -3 : -4))));
            return Environment.GetEnvironmentVariable("RSG_ORDER") == "reverse" ? Expr.Or(b,a) : Expr.Or(a,b);
        }

        private VCGenOutcome RunRsgExperiment() {
            Function seed = program.TopLevelDeclarations.OfType<Function>().FirstOrDefault(f => f.Name == "RSG_seed");
            Expr input = seed != null ? seed.Body : RsgFixedSeed(false);
            if (Environment.GetEnvironmentVariable("RSG_ATTRS") == "unary")
                attribute2Expr["b1"] = attribute2Expr["b1"].Where(kv => kv.Value is IdentifierExpr).ToDictionary(kv => kv.Key,kv => kv.Value);
            Console.WriteLine("[RSG_ENTRY] MLHoudini.modifiedGeneralizeRS_2; RSLearn bypassed");
            Console.WriteLine("[RSG_ATTRIBUTES] " + String.Join(";",attribute2Expr["b1"].Values.Select(v => v.ToString())));
            Console.WriteLine("[RSG_INPUT_SMT] " + RsgSmt(input));
            Console.WriteLine("[INFO] Current RS: " + input);
            string marker = Environment.GetEnvironmentVariable("RSG_INJECT_ONCE");
            if (!String.IsNullOrEmpty(marker)) File.WriteAllText(marker,"first RSLearn call replaced\n");
            bool oracle = Environment.GetEnvironmentVariable("RSG_ORACLE") == "1";
            var watch = Stopwatch.StartNew();
            Expr result = oracle ? RsgFixedSeed(true) : modifiedGeneralizeRS_2(input);
            watch.Stop();
            if (oracle) Console.WriteLine("[INFO] Generalized RS: " + result);
            Console.WriteLine("[RSG_OUTPUT_SMT] " + RsgSmt(result));
            Console.WriteLine("[RSG_WALL_SECONDS] " + watch.Elapsed.TotalSeconds.ToString("R",CultureInfo.InvariantCulture));
            Console.WriteLine("[RSG_ORACLE] " + oracle);
            Console.WriteLine("Prover time = 0.00"); // No RSLearn prover calls; RSG time is separately recorded.
            Console.WriteLine("Number of prover queries = 0");
            Console.WriteLine("C5 Learner time = 0.00");
            Console.WriteLine("Number of C5 Learner queries = 0");
            return new VCGenOutcome(ProverInterface.Outcome.Valid,new List<Counterexample>());
        }

        private static string RsgSmt(Expr e) {
            var literal = e as LiteralExpr;
            if (literal != null) return literal.ToString();
            var id = e as IdentifierExpr;
            if (id != null) return "|" + id.Name + "|";
            var n = e as NAryExpr;
            if (n == null) throw new InvalidOperationException("Unsupported experiment AST: "+e.GetType());
            string op=n.Fun.FunctionName;
            switch(op) {
                case "&&": op="and"; break;
                case "||": op="or"; break;
                case "!": op="not"; break;
                case "==": op="="; break;
                case "!=": op="distinct"; break;
                case "==>": op="=>"; break;
            }
            return "("+op+" "+String.Join(" ",n.Args.Select(RsgSmt))+")";
        }
    }
}
