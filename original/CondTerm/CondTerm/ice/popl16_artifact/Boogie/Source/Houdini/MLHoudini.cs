#define C5


using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using Microsoft.Boogie;
using Microsoft.Boogie.VCExprAST;
using VC;
using Outcome = VC.VCGen.Outcome;
using Bpl = Microsoft.Boogie;
using System.Diagnostics.Contracts;
using System.IO;
using System.Linq.Expressions;
using System.Security.Policy;
using System.Xml.Serialization;
using Microsoft.Boogie.GraphUtil;
//using Microsoft.Z3;
using Microsoft.Basetypes;
using Newtonsoft.Json;
using System.Text.RegularExpressions;

namespace Microsoft.Boogie.Houdini {
    
    public class C5TreeNode
    {
        public string attribute;
        public int cut;
        public string classification;
        //public C5TreeNode left, right;
        public C5TreeNode[] children;
        //public bool isLeaf;

        public C5TreeNode()
        {
        }

        /*
        public bool Equals(C5TreeNode other)
        {

            if (isLeaf && other.isLeaf)
            {
                return classification.Equals(other.classification);
            }
            else if (!isLeaf && !other.isLeaf)
            {
                return attribute.Equals(other.attribute) && cut == other.cut && left.Equals(other.left) && right.Equals(other.right);
            }
            else
            {
                return false;
            }
        }
        */

        /*
        public Dictionary<string, List<List<Expr>>> constructBoogieExpr(List<Expr> stack, string pc, List<string> functionNames, Dictionary<string, Dictionary<string, Expr>> attr2Expr, Dictionary<string, int> functionID)
        {

        }
        */

        public List<List<Expr>> constructBoogieExpr(List<Expr> stack, Dictionary<string, Expr> attr2Expr)
        {
            Expr decisionExpr = null;
            var finalFormula = new List<List<Expr>>();
            // processing Leaf node
            if (this.children == null)
            {
                if (classification.Equals("true") || classification.Equals("True"))
                {
                    List<Expr> newConjunct = new List<Expr>(stack);
                    finalFormula.Add(newConjunct);
                    return finalFormula;
                }
                else if (classification.Equals("false") || classification.Equals("False"))
                    return finalFormula;
            }
            // processing an internal node
            else
            {                
                Expr attExpr = attr2Expr[this.attribute];
                Debug.Assert(attExpr != null);

                if (attExpr.ShallowType.IsBool)
                {
                    decisionExpr = Expr.Not((attr2Expr[this.attribute].Clone()) as Expr);
                    Debug.Assert(this.cut == 0);
                }
                else if (attExpr.ShallowType.IsInt)
                {
                    Expr attr = (attr2Expr[this.attribute].Clone()) as Expr;
                    Expr threshold = Expr.Literal(this.cut);
                    decisionExpr = Expr.Le(attr, threshold);
                }
                else
                {
                    throw new MLHoudiniInternalError("While constructing a Boogie expression from JSON, encountered a unknown type of attribute");
                }

                stack.Add(decisionExpr);
                Debug.Assert(this.children.Length == 2);
                List<List<Expr>> finalformulaLeft = this.children[0].constructBoogieExpr(stack, attr2Expr);
                stack.RemoveAt(stack.Count() - 1);
                stack.Add(Expr.Not(decisionExpr));
                List<List<Expr>> finalformulaRight = this.children[1].constructBoogieExpr(stack, attr2Expr);
                stack.RemoveAt(stack.Count() - 1);
                finalformulaLeft.AddRange(finalformulaRight);
                return finalformulaLeft;
            }

            return finalFormula;
        }
    }

    public static class ExtendsExpr
    {
        public static Expr replace(Expr expr, List<string> oldvars, List<Expr> newvars)
        {
            if (expr is LiteralExpr)
            {               
                LiteralExpr literalExpr = expr as LiteralExpr;
                return (literalExpr.Clone() as Expr);
            }
            else if (expr is IdentifierExpr)
            {
                IdentifierExpr identExpr = expr as IdentifierExpr;
                Debug.Assert(identExpr != null);
                int index = oldvars.IndexOf(identExpr.Name);
                if (index < 0)
                {
                    return expr;
                }
                Debug.Assert(index >= 0 && index < newvars.Count());
                Expr newExpr = newvars.ElementAt(index);                            
                return (newExpr.Clone() as Expr);
            }
            else if (expr is NAryExpr)
            {
                NAryExpr naryExpr = expr as NAryExpr;
                List<Expr> newargs = new List<Expr>();
                foreach (var exprarg in naryExpr.Args)
                {
                    newargs.Add(replace(exprarg, oldvars, newvars));                    
                }
                return new NAryExpr(Token.NoToken, naryExpr.Fun, newargs);
            }

            throw new MLHoudiniInternalError("Error: learned invariant is an expression of unexpected type!");
        }

        public static Expr conjunction(List<Expr> exprs)
        {
            if (exprs.Count() == 0)
            {
                return Expr.False;
            }
            else if (exprs.Count() == 1)
            {
                return exprs.ElementAt(0);
            }
            else
            {
                Expr lhs = exprs.ElementAt(0);
                exprs.RemoveAt(0);
                Expr rhs = conjunction(exprs);
                return Expr.And(lhs, rhs);
            }
        }

        /*
         * Assume that the argument has atleast one list of exprs in it.
         */
        public static Expr disjunction(List<List<Expr>> exprs)
        {
            Debug.Assert(exprs.Count() > 0);
            if (exprs.Count() == 1)
            {
                return conjunction(exprs.ElementAt(0));
            }
            else
            {
                Expr lhs = conjunction(exprs.ElementAt(0));
                exprs.RemoveAt(0);
                Expr rhs = disjunction(exprs);
                return Expr.Or(lhs, rhs);
            }            
        }

        public static bool EqualityComparer(Expr model, Expr newmodel)
        {
            /*
            if (model is LiteralExpr && newmodel is LiteralExpr)
            {
                LiteralExpr litmodel = model as LiteralExpr;
                LiteralExpr litnewmodel = newmodel as LiteralExpr;
                if (litnewmodel.Val.GetType() == typeof(bool) && litmodel.Val.GetType() == typeof(bool))
                {
                    return litnewmodel.Val == litmodel.Val;
                }
                else if (litnewmodel.Val.GetType() == typeof(BigNum) && litmodel.Val.GetType() == typeof(BigNum))
                {
                    return litnewmodel.Val.Equals(litmodel);
                }
                else if (litnewmodel.Val.GetType() == typeof(BigDec) && litmodel.Val.GetType() == typeof(BigDec))
                {
                    litnewmodel.Val.
                }


                return (literalExpr.Clone() as Expr);
            }
            else if (model is IdentifierExpr && newmodel is IdentifierExpr)
            {
                IdentifierExpr identExpr = expr as IdentifierExpr;
                Debug.Assert(identExpr != null);
                int index = oldvars.IndexOf(identExpr.Name);
                Debug.Assert(index >= 0 && index < newvars.Count());
                Expr newExpr = newvars.ElementAt(index);
                return (newExpr.Clone() as Expr);
            }
            else if (expr is NAryExpr)
            {
                NAryExpr naryExpr = expr as NAryExpr;
                List<Expr> newargs = new List<Expr>();
                foreach (var exprarg in naryExpr.Args)
                {
                    newargs.Add(replace(exprarg, oldvars, newvars));
                }
                return new NAryExpr(Token.NoToken, naryExpr.Fun, newargs);
            }*/
            return model.ToString() == newmodel.ToString();            
        }
    }

    public class dataPoint
    {
        public List<int> value;
        public string functionName;
        public string attr = "";

        // public dataPoint(string functionName, List<int> values)
        // {
        //     this.value = values;
        //     this.functionName = functionName;
        // }
        
        public dataPoint(List<int> value, string funcName = "b0", string attr = "")
        {
            this.value = value;
            this.functionName = funcName;
            this.attr = attr;
        }
        
        public dataPoint(string funcName, List<Model.Element> lm)
        {
            try
            {
                List<int> ret = new List<int>();
                foreach (var m in lm)
                {
                    if (m.Kind == Model.ElementKind.Boolean)
                    {
                        bool val = (m as Model.Boolean).Value;
                        if (val)
                        {
                            ret.Add(1);
                        }
                        else
                        {
                            ret.Add(0);
                        }
                    }
                    else if (m.Kind == Model.ElementKind.DataValue)
                    {
                        Model.DatatypeValue dv = (m as Model.DatatypeValue);
                        Debug.Assert(dv != null);
                        Debug.Assert(dv.Arguments.Count() == 1);
                        Model.Element arg = dv.Arguments[0];
                        Debug.Assert(arg.Kind == Model.ElementKind.Integer);
                        if (dv.ConstructorName.Equals("-"))
                        {
                            ret.Add(-1 * arg.AsInt());
                        }
                        else if (dv.ConstructorName.Equals("+"))
                        {
                            ret.Add(arg.AsInt());
                        }
                        else
                        {
                            throw new MLHoudiniInternalError("Unexpected constructor name in the data value returned by the model\n");
                        }
                    }
                    else
                    {
                        Debug.Assert(m.Kind == Model.ElementKind.Integer);
                        ret.Add(m.AsInt());
                    }
                }
                value = ret;
                functionName = funcName;
            }
            catch(Exception e)
            {
                Console.WriteLine("Exception caught while converting model into a list of integer");
                throw e;
            }
        }

        public override int GetHashCode()
        {
                if (this.value != null && this.functionName != null)
                    return this.value.Count + 100 * this.functionName.GetHashCode();
                else return 0;
        }

        public override bool Equals(object obj)
        {
                dataPoint other = obj as dataPoint;
                if (other == null)
                    return false;
                return this.value.SequenceEqual(other.value) && this.functionName.Equals(other.functionName);
        }

        public int maxAbs()
        {
            if (this.value != null && this.value.Count > 0)
            {
                int maxAbs = this.value.Select(num => Math.Abs(num)).Max();
                return maxAbs;
            }
            Console.WriteLine("[Warning] Calculate maxAbs: no value!");
            return 0;
        }
        
        public void setAttr(string attr)
        {
            this.attr = attr;
        }

        public string print()
        {
            string ret = this.functionName + ":";
            if(value.Count() == 0)
            {
                ret += "empty";
            }
            else
            {
                ret += value[0].ToString();
            }
            for(int i = 1; i < value.Count(); i++)
            {
                ret += "," + value[i].ToString();
            }
            return ret;
        }
    }

    public class MLHoudini
    {
        // the tuple is <index, type, bound>
        // type == 0 means ge, type == 1 means le
        private Dictionary<string, Tuple<int, int, int>> constant2GeneralizeExpr;
        private HashSet<Tuple<List<string>, dataPoint>> constantsGeneralized;
        private Dictionary<string, Expr> RSConstant2GeneralizeExpr;

        Dictionary<string, Function> existentialFunctions;
        Program program;
        Dictionary<string, Implementation> name2Impl;
        Dictionary<string, VCExpr> impl2VC;
        Dictionary<string, List<Tuple<string, Function, NAryExpr>>> impl2FuncCalls;
        
        Dictionary<string, HavocCmd> havocInstruments;
        
        // constant -> the naryexpr that it replaced
        Dictionary<string, NAryExpr> constant2FuncCall;

        private HashSet<string> functionForRecurrentSet;

        // function -> its abstract value
        Dictionary<string, MLICEDomain> function2Value;

        private Dictionary<string, Expr> extraFunc2Value;

        Dictionary<string, Dictionary<string, Expr>> attribute2Expr;
        Dictionary<string, int> functionID;

        public const string attrPrefix = "$";
        public const string pcAttrName = "$pc";

        // impl -> functions assumed/asserted
        Dictionary<string, HashSet<string>> impl2functionsAsserted, impl2functionsAssumed;

        // funtions -> impls where assumed/asserted
        Dictionary<string, HashSet<string>> function2implAssumed, function2implAsserted;

        // impl -> handler, collector
        Dictionary<string, Tuple<ProverInterface.ErrorHandler, MLHoudiniCounterexampleCollector>> impl2ErrorHandler;

        // Essentials: VCGen, Prover
        VCGen vcgen;
        ProverInterface prover;
        // List that contains the bounds for values in cex to try.
        List<int> bounds4cex;

        // NOTE: the counter records the number of iteration before the current positive example
        // is found to be spurious
        // it is incremented each time an implication ce is added
        // and reset when learning fails due to inconsistency
        // (at which point a generalization begins)

        // name of the Boogie program being verified: used for generating C5 files.
        string filename;
        string config;
        bool useBounds;
        
        // _ADD: record index of variables in .names file: used for generating .dup.data
        // private Dictionary<string, int> var2Index;
        private List<string> vars4IDT;

        // Stats
        TimeSpan proverTime;
        int numProverQueries;
        TimeSpan c5LearnerTime;
        int c5LearnerQueries;
        TimeSpan totaltime;
        TimeSpan jsontime;

        int numPosExamples;
        int numNegCounterExamples;
        int numImplications;
        int totalTreeSize;
        int lastTreeSize;
        int total_truetrue_implications;
        int last_truetrue_implications;
        int total_falsetrue_implications;
        int last_falsetrue_implications;
        int total_falsefalse_implications;
        int last_falsefalse_implications;
        //bool posNegCexAdded;

        // Z3 context for implementing the SMT-based ICE learner.
        HashSet<Tuple<List<Tuple<string, List<Model.Element>>>, List<Tuple<string, List<Model.Element>>>>> counterExamples;
        HashSet<Tuple<List<Tuple<string, List<Model.Element>>>, List<Tuple<string, List<Model.Element>>>>> implicationCounterExamples;        

#if C5
        // Data structures for storing and creating C5 sample
        Dictionary<dataPoint, int> c5samplePointToClassAttr;
        Dictionary<dataPoint, int> c5samplePointToIndex;
        private int c5sampleMaxAbs = 0;  // for data sharing
        List<Tuple<int, int>> c5implications;

        private Dictionary<dataPoint, HashSet<dataPoint>> implicationDictionary;
        int c5DataPointsIndex;

        private HashSet<dataPoint> terminatingStateSamplesSet;
#endif

        private Implementation implWithRS;
        private Tuple<int, Block> instrumentationMapForRS;
        private Dictionary<int, Implementation> helperImpls;

        // flags to track the outcome of validity of a VC
        bool VCisValid;
        //bool realErrorEncountered;
        //bool newSamplesAdded;   // tracks whether new ICE samples added in a round or not?

        private bool HavocApproximated = false;

        private bool hasRecurrentSet
        {
            get
            {
                return this.implWithRS != null;
            }
        }

        private List<int> boundForGeneralization;
        private List<int> boundForRSGeneralization;
        
        public MLHoudini(Program program, string config, string filename, bool useBounds,
            Program InstrumentedProgram=null, Implementation InstrumentedImpl=null,
            Dictionary<int, Implementation> helperImpls=null)
        {
            this.program = program;
            
            this.impl2VC = new Dictionary<string, VCExpr>();
            this.impl2FuncCalls = new Dictionary<string, List<Tuple<string, Function, NAryExpr>>>();
            
            this.havocInstruments = new Dictionary<string, HavocCmd>();
            this.extraFunc2Value = new Dictionary<string, Expr>();
            
            this.existentialFunctions = new Dictionary<string, Function>();
            this.name2Impl = new Dictionary<string, Implementation>();
            this.impl2functionsAsserted = new Dictionary<string, HashSet<string>>();
            this.impl2functionsAssumed = new Dictionary<string, HashSet<string>>();
            this.function2implAsserted = new Dictionary<string, HashSet<string>>();
            this.function2implAssumed = new Dictionary<string, HashSet<string>>();
            this.impl2ErrorHandler = new Dictionary<string, Tuple<ProverInterface.ErrorHandler, MLHoudiniCounterexampleCollector>>();
            this.constant2FuncCall = new Dictionary<string, NAryExpr>();
            this.functionForRecurrentSet = new HashSet<string>();

            this.constant2GeneralizeExpr = new Dictionary<string, Tuple<int, int, int>>();
            this.constantsGeneralized = new HashSet<Tuple<List<string>, dataPoint>>();
            this.RSConstant2GeneralizeExpr = new Dictionary<string, Expr>();

            // Find the existential functions
            foreach (var func in program.TopLevelDeclarations.OfType<Function>()
                .Where(f => QKeyValue.FindBoolAttribute(f.Attributes, "existential")))
                existentialFunctions.Add(func.Name, func);

            // extract the constants in the program to determine the range for the template domain elements
            this.function2Value = new Dictionary<string, MLICEDomain>();
            foreach (var func in existentialFunctions.Values)
            {
                function2Value[func.Name] = new C5Domain(func.InParams);
            }

            counterExamples = new HashSet<Tuple<List<Tuple<string, List<Model.Element>>>, List<Tuple<string, List<Model.Element>>>>>();
            implicationCounterExamples = new HashSet<Tuple<List<Tuple<string, List<Model.Element>>>, List<Tuple<string, List<Model.Element>>>>>();
            bounds4cex = new List<int>();
            this.filename = filename;
            this.config = config;
            this.useBounds = useBounds;
            // this.var2Index = new Dictionary<string, int>();
            this.vars4IDT = new List<string>();

            // config = alg1, alg2, alg3, alg4, smallcex_alg1, smallcex_alg2, ...

            if (this.useBounds)
            {
                bounds4cex.Add(2);
                bounds4cex.Add(5);
                bounds4cex.Add(10);
            }

            existentialFunctions.Keys.Iter(f => function2implAssumed.Add(f, new HashSet<string>()));
            existentialFunctions.Keys.Iter(f => function2implAsserted.Add(f, new HashSet<string>()));

            // type check
            existentialFunctions.Values.Iter(func =>
                {
                    if (func.OutParams.Count != 1 || !func.OutParams[0].TypedIdent.Type.IsBool)
                        throw new MLHoudiniInternalError(string.Format("Existential function {0} must return bool", func.Name));
                    if (func.Body != null)
                        throw new MLHoudiniInternalError(string.Format("Existential function {0} should not have a body", func.Name));
                    func.InParams.Iter(v =>
                    {
                        if (!v.TypedIdent.Type.IsInt && !v.TypedIdent.Type.IsBool)
                        {
                            throw new MLHoudiniInternalError("TypeError: Illegal tpe, expecting int or bool");
                        }
                    });
                });
           
            Inline();
            
            this.vcgen = new VCGen(program, CommandLineOptions.Clo.SimplifyLogFilePath, CommandLineOptions.Clo.SimplifyLogFileAppend, new List<Checker>());
            this.prover = ProverInterface.CreateProver(program, CommandLineOptions.Clo.SimplifyLogFilePath, CommandLineOptions.Clo.SimplifyLogFileAppend, CommandLineOptions.Clo.ProverKillTime);
             
            this.proverTime = TimeSpan.Zero;
            this.numProverQueries = 0;
            this.c5LearnerTime = TimeSpan.Zero;
            this.c5LearnerQueries = 0;
            this.totaltime = TimeSpan.Zero;
            this.jsontime = TimeSpan.Zero;

            this.numPosExamples = 0;
            this.numNegCounterExamples = 0;
            this.numImplications = 0;
            this.total_falsefalse_implications = 0;
            this.total_falsetrue_implications = 0;
            this.total_truetrue_implications = 0;
            this.totalTreeSize = 0;
            this.last_falsefalse_implications = 0;
            this.last_falsetrue_implications = 0;
            this.last_truetrue_implications = 0;
            this.lastTreeSize = 0;
            //this.posNegCexAdded = false;

#if C5
            this.c5DataPointsIndex = 0;
            this.c5samplePointToClassAttr = new Dictionary<dataPoint, int>();
            this.c5samplePointToIndex = new Dictionary<dataPoint, int>();
            this.c5implications = new List<Tuple<int, int>>();
            this.implicationDictionary = new Dictionary<dataPoint, HashSet<dataPoint>>();

            if (!CommandLineOptions.Clo.RSInfer)
            {
                // load reuse data
                loadReuse();
            }
            else
            {
                // loadMData();
                loadStorage();
            }

            // dataPoint dummy = new dataPoint("b0", new List<int>{1});
            // c5samplePointToIndex[dummy] = 0;
            // c5samplePointToClassAttr[dummy] = 1;
            // c5DataPointsIndex++;
            this.terminatingStateSamplesSet = new HashSet<dataPoint>(); // TODO: probably need update for the generalization?
#endif


            this.boundForGeneralization = new List<int>();
            boundForGeneralization.Add(0);
            boundForGeneralization.Add(1);
            boundForGeneralization.Add(2);
            boundForGeneralization.Add(4);
            boundForGeneralization.Add(6);
            boundForGeneralization.Add(8);
            boundForGeneralization.Add(10);
            boundForGeneralization.Add(20);
            boundForGeneralization.Reverse();
            
            this.boundForRSGeneralization = new List<int>();
            boundForRSGeneralization.Add(0);
            boundForRSGeneralization.Add(1);
            boundForRSGeneralization.Add(2);
            boundForRSGeneralization.Add(4);
            boundForRSGeneralization.Add(6);
            boundForRSGeneralization.Add(8);
            boundForRSGeneralization.Add(10);
            boundForRSGeneralization.Add(20);
            boundForRSGeneralization.Add(50);
            // boundForRSGeneralization.Reverse();
            
            this.generalization_enabled = !CommandLineOptions.Clo.NoGeneralization;
            
            var impls = program.TopLevelDeclarations.OfType<Implementation>().Where(
                    impl => impl != null && CommandLineOptions.Clo.UserWantsToCheckRoutine(cce.NonNull(impl.Name)) && !impl.SkipVerification);

            // foreach (var impl in impls)
            // {
            //     var instrumenter = new HavocInstrumenter();
            //     instrumenter.VisitBlockList(impl.Blocks);
            //     this.havocInstruments = instrumenter.func2Cmds;
            //     foreach (var f in instrumenter.constants)
            //     {
            //         extraFunc2Value[f.Name] = Expr.True;
            //     }
            // }
            
            /*
            program.TopLevelDeclarations.OfType<Implementation>()
                .Where(impl => !impl.SkipVerification)
                .Iter(impl => name2Impl.Add(impl.Name, impl));
            */

            impls.Iter(impl => name2Impl.Add(impl.Name, impl));

            // Call setupC5 only after the filename has been initialized!
            setupC5();

            // Let's do VC Gen (and also build dependencies)
            name2Impl.Values.Iter(GenVC);

            #region check recurrent set

            if (InstrumentedImpl != null)
            {
                this.implWithRS = InstrumentedImpl;
                // do not mess up with the major impl.
                implWithRS.Name = implWithRS.Name + "_instrumented";
                GenVC(implWithRS);
                foreach (var f in existentialFunctions.Keys)
                {
                    // HACK
                    function2implAsserted[f].Remove(implWithRS.Name);
                    function2implAssumed[f].Remove(implWithRS.Name);
                }
                
                // find the loop guard
                // findLoopGuard();
            }
            
            // preprocess the helpers
            
            this.helperImpls = helperImpls;
            if (generalization_enabled && helperImpls != null)
            {
                
                foreach (var p in helperImpls)
                {
                    int iteration = p.Key;
                    Implementation implementation = p.Value;
                    implementation.Name = implementation.Name + "_helper_" + iteration;
                    
                    GenVC(implementation);
                    foreach (var f in existentialFunctions.Keys)
                    {
                        // HACK
                        function2implAsserted[f].Remove(implementation.Name);
                        function2implAssumed[f].Remove(implementation.Name);
                    }
                }

            }
            
            // if (implWithRS != null)
            // {
            //     var index = instrumentationMapForRS.Item1;
            //     var newBlock = instrumentationMapForRS.Item2;
            //
            //     string name = implWithRS.Name;
            //     var origBlock = implWithRS.Blocks[index];
            //     implWithRS.Blocks[index] = newBlock;
            //     implWithRS.Name = implWithRS.Name + "_instrumented";
            //     
            //     GenVC(implWithRS);
            //
            //     implWithRS.Name = name;
            //     implWithRS.Blocks[index] = origBlock;
            // }
            #endregion
            
            // this.instrumentedProgram = instrumentedPgm;
            // this.instrumentedImpl = instrumentedImpl;

            // GenVC(instrumentedImpl);
        }

        private void findLoopGuard()
        {
            Block b = null;
            foreach (var block in this.implWithRS.Blocks)
            {
                foreach (var command in block.Cmds)
                {
                    if (command is RecurrentSetMaintainAssertCmd)
                    {
                        b = block;
                        goto outer;
                    }
                }
            }
        outer:
            if (b != null)
            {
                Cmd c = b.Cmds[0];
                if (c is AssumeCmd)
                {
                    this.implWithRS.LoopGuardExprForRS = ((AssumeCmd)c).Expr;
                }
                else
                {
                    Console.WriteLine("Warning: the first expression in this block is not assume command");
                }
            }
        }


        private void generateAttributes(int num)
        {
            int[] array = new int[num];
            for (int i = 0; i < num; i++)
                array[i] = 0;
        }
        
        // XRC_ADD_BEGIN
        List<dataPoint> posReuseList = new List<dataPoint>();
        List<dataPoint> negReuseList = new List<dataPoint>();
        List<Tuple<dataPoint,dataPoint>> impReuseList = new List<Tuple<dataPoint,dataPoint>>();
        int currentReuseMax = 0;
        int currentPosReusedIndex = 0;
        int currentNegReusedIndex = 0;
        int currentImpReusedIndex = 0;
        int posReuseNum = 0;
        int negReuseNum = 0;
        int impReuseNum = 0;
        int currentMDataReused = 0;
        private HashSet<int> indexReused = new HashSet<int>();
        int max_abslute_size = 2;
        int max_relative_size = 10;
        // private void loadReuse(int lowerBound=0, int upperbound=1000000)
        private void loadReuse()
        {
            // System.Console.WriteLine("[Debug] RUS file path: " + filename + ".rus");
            if (!System.IO.File.Exists(filename + ".rus"))
                return;
            // System.Console.WriteLine("[Debug] Reuse file found");
            string[] lines = System.IO.File.ReadAllLines(filename + ".rus");
            foreach (var line in lines)
            {
                if(line.StartsWith("Pos"))
                {
                    var patternPos = @"Pos:\((?<State>.*)\)";
                    var group = Regex.Match(line, patternPos).Groups;
                    var State = group["State"].Value.Split(',').Select(item => Int32.Parse(item.Trim())).ToList();
                    // var useMe = true;
                    // foreach(var v in State)
                    // {
                    //     var vp = v;
                    //     if(vp < 0) vp = -vp;
                    //     if(vp < lowerBound || vp > upperbound){
                    //         useMe = false;
                    //         break;
                    //     }
                    // }
                    // if(!useMe)
                    //     continue;
                    var data = new dataPoint(State);
                    // if(!c5samplePointToIndex.ContainsKey(data))
                    // {
                    //     c5samplePointToIndex[data] = c5DataPointsIndex++;
                    //     c5samplePointToClassAttr[data] = 1; // Pos
                    // }                        
                    posReuseList.Add(data);
                    // System.Console.WriteLine("[Debug] Found a pos line: " + line);
                }
                else if (line.StartsWith("Neg"))
                {
                    var patternNeg = @"Neg:\((?<State>.*)\)";
                    var group = Regex.Match(line, patternNeg).Groups;
                    var State = group["State"].Value.Split(',').Select(item => Int32.Parse(item.Trim())).ToList();
                    // var useMe = true;
                    // foreach(var v in State)
                    // {
                    //     var vp = v;
                    //     if(vp < 0) vp = -vp;
                    //     if(vp < lowerBound || vp > upperbound){
                    //         useMe = false;
                    //         break;
                    //     }
                    // }
                    // if(!useMe)
                    //     continue;
                    var data = new dataPoint(State);
                    // if(!c5samplePointToIndex.ContainsKey(data))
                    // {
                    //     c5samplePointToIndex[data] = c5DataPointsIndex++;
                    //     c5samplePointToClassAttr[data] = 2; // Neg
                    // }
                    negReuseList.Add(data);
                    // System.Console.WriteLine("[Debug] Found a neg line: " + line);
                }
                else if (line.StartsWith("Imp"))
                {
                    var patternNeg = @"Imp:\((?<State0>.*)\)=>\((?<State1>.*)\)";
                    var group = Regex.Match(line, patternNeg).Groups;
                    var State0 = group["State0"].Value.Split(',').Select(item => Int32.Parse(item.Trim())).ToList();
                    var State1 = group["State1"].Value.Split(',').Select(item => Int32.Parse(item.Trim())).ToList();
                    // var useMe = true;
                    // foreach(var v in State0)
                    // {
                    //     var vp = v;
                    //     if(vp < 0) vp = -vp;
                    //     if(vp < lowerBound || vp > upperbound){
                    //         useMe = false;
                    //         break;
                    //     }
                    // }
                    // if(!useMe)
                    //     continue;
                    // foreach(var v in State1)
                    // {
                    //     var vp = v;
                    //     if(vp < 0) vp = -vp;
                    //     if(vp < lowerBound || vp > upperbound){
                    //         useMe = false;
                    //         break;
                    //     }
                    // }
                    // if(!useMe)
                    //     continue;
                    var data0 = new dataPoint(State0);
                    var data1 = new dataPoint(State1);
                    // if(!c5samplePointToIndex.ContainsKey(data0))
                    // {
                    //     c5samplePointToIndex[data0] = c5DataPointsIndex++;
                    //     c5samplePointToClassAttr[data0] = 0; // Unknown
                    // }
                    // if(!c5samplePointToIndex.ContainsKey(data1))
                    // {
                    //     c5samplePointToIndex[data1] = c5DataPointsIndex++;
                    //     c5samplePointToClassAttr[data1] = 0; // Unknown
                    // }
                    // c5implications.Add(new Tuple<int, int>(c5samplePointToIndex[data0], c5samplePointToIndex[data1]));
                    impReuseList.Add(new Tuple<dataPoint, dataPoint> (data0,data1));
                    // System.Console.WriteLine("[Debug] Found an imp line: " + line);
                }
                else if (line.StartsWith("Parameter:")) {
                    var patternParam = @"Parameter:(?<Name>.*)=(?<Value>.*)";
                    var group = Regex.Match(line, patternParam).Groups;
                    var Name = group["Name"].Value.Trim();
                    int Value = 0;
                    switch (Name)
                    {
                        case "max_abslute_size":
                            Value = Int32.Parse(group["Value"].Value.Trim());
                            max_abslute_size = Value;
                            break;
                        case "max_relative_size":
                            Value = Int32.Parse(group["Value"].Value.Trim());
                            max_relative_size = Value;
                            break;
                        default:
                            break;
                    }
                }
            }
            // posReuseList = posReuseList.OrderBy(obj => obj.value.Select(x => Math.Abs(x)).Max()).ToList();
            // negReuseList = negReuseList.OrderBy(obj => obj.value.Select(x => Math.Abs(x)).Max()).ToList();
            // impReuseList = impReuseList.OrderBy(obj => Math.Max(obj.Item1.value.Select(x => Math.Abs(x)).Max(), obj.Item2.value.Select(x => Math.Abs(x)).Max())).ToList();
            // System.Console.WriteLine(String.Format("[Debug] The max c5DataPointsIndex after REUSE is: {0}", c5DataPointsIndex - 1));
        }
        // XRC_ADD_END

        // _ADD_BEGIN
        List<dataPoint> storage_all_samples = new List<dataPoint>();
        List<dataPoint> storage_term_samples = new List<dataPoint>();
        List<Tuple<dataPoint,dataPoint>> storage_imp = new List<Tuple<dataPoint,dataPoint>>();
        int rs_currentTermReusedIndex = 0;
        int rs_currentImpReusedIndex = 0;
        int rs_TermReusedNum = 0;
        int rs_ImpReusedNum = 0;
        private int storage_currentReuseMax = 0;
        // int condterm_max_ratio = CommandLineOptions.Clo.dsRatio;
        int condterm_max_ratio = 10;
        int condterm_max_abslute_size = 1;

        private void loadStorage()
        {
            // load csv
            System.Console.WriteLine("[Debug] Storage CSV file path: " + CommandLineOptions.Clo.StorageCSV);
            if (!System.IO.File.Exists(CommandLineOptions.Clo.StorageCSV)) 
            {
                Console.WriteLine("[Warning] Storage CSV file not found, ignored");
                return;
            }
            int term_index = 0;
            int index = 0;
            String[] lines = System.IO.File.ReadAllLines(CommandLineOptions.Clo.StorageCSV);
            foreach (var line in lines)
            {
                if (line.Contains("attr"))
                {
                    continue;
                }
                string[] values = line.Split(',');
                var rawState = values.Take(values.Length - 2).ToArray();
                var State = rawState.Select(item => Int32.Parse(item.Trim())).ToList();
                var data = new dataPoint(State, "b1");
                if (line.Contains("term"))  // terminating samples
                {
                    // data = new dataPoint(State, "b1", "term");
                    data.setAttr("term");
                    storage_term_samples.Add(data);
                    term_index += 1;
                }
                storage_all_samples.Add(data);
                index += 1;
            }
            Console.WriteLine("[Debug] Successfully add " + index + " samples, with " + term_index + " terminating.");
            
            // load imp
            System.Console.WriteLine("[Debug] Storage IMP file path: " + CommandLineOptions.Clo.StorageIMP);
            if (!System.IO.File.Exists(CommandLineOptions.Clo.StorageIMP)) 
            {
                Console.WriteLine("[Warning] Storage IMP file not found, ignored");
                return;
            }
            int imp_index = 0;
            String[] imp_lines = System.IO.File.ReadAllLines(CommandLineOptions.Clo.StorageIMP);
            foreach(var line in imp_lines)
            {
                string[] impinfo = line.Split(' ');
                int l_index = Int32.Parse(impinfo[0].Trim());
                int r_index = Int32.Parse(impinfo[1].Trim());
                if (l_index == r_index)
                    continue;
                var imp = new Tuple<dataPoint, dataPoint>(storage_all_samples[l_index], storage_all_samples[r_index]);
                storage_imp.Add(imp);
                imp_index += 1;
            }
            Console.WriteLine("[Debug] Successfully add " + imp_index + " imp samples.");
        }
        // old data sharing
        private List<dataPoint> mDataList = new List<dataPoint>();
        private void loadMData()
        {
            System.Console.WriteLine("[Debug] MData file path: " + CommandLineOptions.Clo.MDataPath);
            if (!System.IO.File.Exists(CommandLineOptions.Clo.MDataPath)) 
            {
                Console.WriteLine("[Warning] MData file not found, ignored");
                return;
            }
            String[] lines = System.IO.File.ReadAllLines(CommandLineOptions.Clo.MDataPath);
            bool isTitle = true;
            int index = 0;
            foreach (var line in lines)
            {
                if (isTitle)
                {
                    isTitle = false;
                    continue;
                }
                var State = line.Split(',').Select(item => Int32.Parse(item.Trim())).ToList();
                // State.RemoveAt(State.Count-1);
                var data = new dataPoint(State, "b1");
                mDataList.Add(data);
                // System.Console.WriteLine("[Debug] Add a MData: " + line);
                index += 1;
            }
            Console.WriteLine("[Debug] Successfully add " + index + " MData.");
        }
        // _ADD_END
        

        private void setupC5()
        {
            string namesFile = "";
            string intervalsFile = "";
            int lowerInterval = 2, upperInterval = 2;

            namesFile += "invariant.\n";
            // output pcs
            // pc : pc1,pc2,pc3,pc4.
            namesFile += pcAttrName + " : ";
            {
                int i = 0;
                foreach (var functionName in existentialFunctions.Keys)
                {
                    namesFile += functionName + (i < existentialFunctions.Keys.Count - 1 ? "," : "");
                    i++;
                }

                // If there exists only one existential function, we need to add a dummy function to fool the C5 learner, which does not allow a discrete attribute with just one attribute value
                if (i == 1)
                {
                    namesFile += "," + pcAttrName + "_dummy";
                }

                namesFile += "." + Environment.NewLine;

            }

            attribute2Expr = new Dictionary<string, Dictionary<string, Expr>>();
            functionID = new Dictionary<string, int>();

            int index = 0;
            foreach (var funTup in existentialFunctions)
            {
                Dictionary<string, Expr> newentry = new Dictionary<string, Expr>();
                List<Variable> args = funTup.Value.InParams;

                foreach (var variable in args)
                {
                    if (variable.TypedIdent.Type.IsBool || variable.TypedIdent.Type.IsInt)
                    {
                        newentry[funTup.Key + "$" + variable.Name] = Expr.Ident(variable);
                        Debug.Assert(newentry[funTup.Key + "$" + variable.Name].ShallowType.IsInt || newentry[funTup.Key + "$" + variable.Name].ShallowType.IsBool);
                        namesFile += funTup.Key + "$" + variable.Name + ": continuous.\n";
                        upperInterval++;
                        // var2Index.Add(variable.Name, index);
                        // index++;
                        vars4IDT.Add(variable.Name);
                    }
                    else
                    {
                        throw new MLHoudiniInternalError("Existential Functions should have either Boolean or Int typed arguments!");
                    }
                }


                // Commented out right now
                #region Introducing attributes with arbitrary number of variables
                /*
                int num = args.Count();
                int[] array = new int[num];
                for (int i = 0; i < num; i++)
                    array[i] = 0;

                int done = 0;
                while (true)
                {
                    for (int i = 0; i < num; i++)
                    {
                        if (array[i] < 2)
                        {
                            array[i]++;
                            break;
                        }
                        else if (i == num - 1)
                        {
                            done = 1;
                            break;
                        }
                        else
                        {
                            array[i] = 0;
                        }
                    }

                    if (done == 1)
                        break;
                    
                    int numArgs = 0;
                    for (int i = 0; i < num; i++)
                    {
                        if (array[i] != 0)
                            numArgs++;                        
                    }

                    if (numArgs == 1)
                        continue;

                    int j = 0;
                    Expr attrexpr = null;
                    string lhs = null;
                    string rhs = null;

                   
                        foreach (var variable in args)
                        {
                            if (array[j] == 1)
                            {
                                Variable var = args.ElementAt(j);
                                if (attrexpr == null)
                                {
                                    attrexpr = Expr.Ident(var);
                                }
                                else
                                {
                                    attrexpr = Expr.Add(attrexpr, Expr.Ident(var));
                                }

                                if (lhs == null)
                                {
                                    lhs = attrPrefix + funTup.Key + "$" + "+" + var.Name;
                                }
                                else
                                {
                                    lhs = lhs + "+" + var.Name;
                                }

                                if (rhs == null)
                                {
                                    rhs = "+" + funTup.Key + "$" + var.Name;
                                }
                                else
                                {
                                    rhs = rhs + "+" + funTup.Key + "$" + var.Name;
                                }

                                
                            }

                            else if (array[j] == 2)
                            {
                                Variable var = args.ElementAt(j);
                                if (attrexpr == null)
                                {
                                    attrexpr = Expr.Sub(Expr.Literal(0), Expr.Ident(var));
                                }
                                else
                                {
                                    attrexpr = Expr.Sub(attrexpr, Expr.Ident(var));
                                }

                                if (lhs == null)
                                {
                                    lhs = attrPrefix + funTup.Key + "$" + "-" + var.Name;
                                }
                                else
                                {
                                    lhs = lhs + "-" + var.Name;
                                }

                                if (rhs == null)
                                {
                                    rhs = "-" + funTup.Key + "$" + var.Name;
                                }
                                else
                                {
                                    rhs = rhs + "-" + funTup.Key + "$" + var.Name;
                                }                                
                            }
                            j++;
                        }

                        newentry[lhs] = attrexpr;
                        Debug.Assert(newentry[lhs].ShallowType.IsInt || newentry[lhs].ShallowType.IsBool);
                        namesFile += lhs + ":= " + rhs + ".\n";

                        upperInterval++;
                        

                }
                 * */
#endregion Introducing attributes with arbitrary number of variables


                // Add implicitly defined attributes of the form x1 +/- x2
                for (int i = 0; i < args.Count; i++)
                {
                    for (int j = i + 1; j < args.Count; j++)
                    {
                        Variable var1 = args.ElementAt(i);
                        Variable var2 = args.ElementAt(j);
                        if (!CommandLineOptions.Clo.RSInfer)
                        {
                            if (var1.Name.StartsWith("TR") || var2.Name.StartsWith("TR"))
                                continue;
                        }
                        if (var1.TypedIdent.Type.IsInt && var2.TypedIdent.Type.IsInt)
                        {
                            newentry[attrPrefix + funTup.Key + "$" + var1.Name + "+" + var2.Name] = Expr.Add(Expr.Ident(var1), Expr.Ident(var2));
                            Debug.Assert(newentry[attrPrefix + funTup.Key + "$" + var1.Name + "+" + var2.Name].ShallowType.IsInt || newentry[attrPrefix + funTup.Key + "$" + var1.Name + "+" + var2.Name].ShallowType.IsBool);
                            newentry[attrPrefix + funTup.Key + "$" + var1.Name + "-" + var2.Name] = Expr.Sub(Expr.Ident(var1), Expr.Ident(var2));
                            Debug.Assert(newentry[attrPrefix + funTup.Key + "$" + var1.Name + "-" + var2.Name].ShallowType.IsInt || newentry[attrPrefix + funTup.Key + "$" + var1.Name + "-" + var2.Name].ShallowType.IsBool);
                            
                            namesFile += attrPrefix + funTup.Key + "$" + var1.Name + "+" + var2.Name + ":= " + funTup.Key + "$" + var1.Name + " + " + funTup.Key + "$" + var2.Name + ".\n";
                            namesFile += attrPrefix + funTup.Key + "$" + var1.Name + "-" + var2.Name + ":= " + funTup.Key + "$" + var1.Name + " - " + funTup.Key + "$" + var2.Name + ".\n";
                            upperInterval += 2;
                        }
                    }
                }


                attribute2Expr[funTup.Key] = newentry;
                functionID[funTup.Key] = functionID.Count;                
                intervalsFile += lowerInterval.ToString() + " " + (upperInterval-1).ToString() + "\n";
                lowerInterval = upperInterval;
                upperInterval = lowerInterval;
            }

            namesFile += "invariant: true, false.\n";
            using (System.IO.StreamWriter sw = System.IO.File.CreateText(filename + ".names"))
            {
                sw.WriteLine(namesFile);
            }
            using (System.IO.StreamWriter sw = System.IO.File.CreateText(filename + ".intervals"))
            {
                if (existentialFunctions.Count == 1)
                {
                    intervalsFile += "2 2";
                }
                sw.WriteLine(intervalsFile);
            }
            return;
        }

        private VCGenOutcome LearnInv(Dictionary<string, int> impl2Priority)
        {
            Console.WriteLine("[Debug] rslearn Reuse: " + CommandLineOptions.Clo.dataShare.ToString() + ", maxRatio=" + condterm_max_ratio.ToString());
            
            var worklist = new SortedSet<Tuple<int, string>>();
            name2Impl.Keys.Iter(k => worklist.Add(Tuple.Create(impl2Priority[k], k)));
            
            while (worklist.Any())
            {
                var impl = worklist.First().Item2;
                worklist.Remove(worklist.First());

                #region vcgen

                var gen = prover.VCExprGen;
                var terms = new List<Expr>();
                foreach (var tup in impl2FuncCalls[impl])
                {
                    var controlVar = tup.Item2;
                    var exprVars = tup.Item3;
                    var varList = new List<Expr>();
                    exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));

                    var args = new List<Expr>();
                    controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                    Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args),
                                 function2Value[tup.Item1].Gamma(varList));

                    if (controlVar.InParams.Count != 0)
                    {
                        term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                            new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                            term);
                    }
                    terms.Add(term);

                    /*
                    foreach (var variable in varList)
                    {
                        terms.Add(Expr.Le(variable, Expr.Literal(10)));
                        terms.Add(Expr.Ge(variable, Expr.Literal(-10)));
                    }
                    */
                }

                foreach (var p in extraFunc2Value)
                {
                    var f = new Function(Token.NoToken, p.Key, new List<Variable>(),
                        new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                    
                    Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(f), new List<Expr>()),
                        p.Value);
                    terms.Add(term);
                }
                
                var env = BinaryTreeAnd(terms, 0, terms.Count - 1);

                env.Typecheck(new TypecheckingContext((IErrorSink)null));
                var envVC = prover.Context.BoogieExprTranslator.Translate(env);
                var vc = gen.Implies(envVC, impl2VC[impl]);

                if (CommandLineOptions.Clo.Trace)
                {
                    Console.WriteLine("Verifying {0}: ", impl);
                    //Console.WriteLine("env: {0}", envVC);
                    var envFuncs = new HashSet<string>();
                    impl2FuncCalls[impl].Iter(tup => envFuncs.Add(tup.Item1));
                    envFuncs.Iter(f => PrintFunction(existentialFunctions[f]));
                }

                #endregion vcgen

                VCExpr finalVC;
                bool hasIntegerVariable = true;

                for (int i = 0; i <= bounds4cex.Count(); i++)
                {
                    #region boundcexvalues
                    // If there are no integer variables, then ensure the loop is only run once.
                    if (!hasIntegerVariable)
                        continue;

                    /* Last iteration is when there are enforced no bounds on the cex values. */
                    if (i < bounds4cex.Count())
                    {
                        int bound = bounds4cex.ElementAt(i);
                        terms.Clear();
                        foreach (var tup in impl2FuncCalls[impl])
                        {
                            var exprVars = tup.Item3;
                            var varList = new List<Expr>();
                            exprVars.Args.OfType<Expr>().Where(v => v.Type.IsInt).Iter(v => varList.Add(v));
                            foreach (var variable in varList)
                            {
                                terms.Add(Expr.Le(variable, Expr.Literal(bound)));
                                terms.Add(Expr.Ge(variable, Expr.Literal(-1 * bound)));
                                //terms.Add(Expr.Ge(variable, Expr.Literal(0)));
                            }
                        }
                        if (terms.Count == 0)
                        {
                            // There is no integer argument to the function to learn
                            hasIntegerVariable = false;
                        }

                        var boundcex = BinaryTreeAnd(terms, 0, terms.Count - 1);
                        boundcex.Typecheck(new TypecheckingContext((IErrorSink)null));
                        var boundcexVC = prover.Context.BoogieExprTranslator.Translate(boundcex);

                        finalVC = gen.Implies(boundcexVC, vc);
                    }
                    else
                    {
                        if (!this.useBounds)
                        {
                            finalVC = vc;
                        }
                        else
                        {
                            int bound = 1000000;
                            terms.Clear();
                            foreach (var tup in impl2FuncCalls[impl])
                            {
                                var exprVars = tup.Item3;
                                var varList = new List<Expr>();
                                exprVars.Args.OfType<Expr>().Where(v => v.Type.IsInt).Iter(v => varList.Add(v));
                                foreach (var variable in varList)
                                {
                                    terms.Add(Expr.Le(variable, Expr.Literal(bound)));
                                    terms.Add(Expr.Ge(variable, Expr.Literal(-1 * bound)));
                                    //terms.Add(Expr.Ge(variable, Expr.Literal(0)));
                                }
                            }
                            var boundcex = BinaryTreeAnd(terms, 0, terms.Count - 1);
                            boundcex.Typecheck(new TypecheckingContext((IErrorSink)null));
                            var boundcexVC = prover.Context.BoogieExprTranslator.Translate(boundcex);

                            finalVC = gen.Implies(boundcexVC, vc);
                        }
                    }
                    #endregion boundcexvalues

                    var handler = impl2ErrorHandler[impl].Item1;
                    var collector = impl2ErrorHandler[impl].Item2;
                    collector.Reset(impl);
                    implicationCounterExamples.Clear();
                    VCisValid = true;   // set to false if control reaches HandleCounterExample
                    //realErrorEncountered = false;
                    //newSamplesAdded = false;
                    //this.posNegCexAdded = false;

                    var start = DateTime.Now;

                    prover.Push();
                    prover.Assert(gen.Not(finalVC), true);
                    prover.FlushAxiomsToTheoremProver();
                    prover.Check();
                    ProverInterface.Outcome proverOutcome = prover.CheckOutcomeCore(handler);

                    var inc = (DateTime.Now - start);
                    proverTime += inc;
                    numProverQueries++;

                    if (CommandLineOptions.Clo.Trace)
                        Console.WriteLine("Prover Time taken = " + inc.TotalSeconds.ToString());

                    if (proverOutcome == ProverInterface.Outcome.TimeOut || proverOutcome == ProverInterface.Outcome.OutOfMemory)
                    {
                        Console.WriteLine("Z3 Prover for implementation {0} times out or runs out of memory !", impl);
                        return new VCGenOutcome(proverOutcome, new List<Counterexample>());
                    }

                    prover.Pop();
                    if (!VCisValid)
                    {
                        /* There was a real counterexample found and acted upon while proving the method. */
                        if (collector.real_errors.Count > 0)
                        { 
                            return new VCGenOutcome(ProverInterface.Outcome.Invalid, collector.real_errors);
                        }

                        if (collector.conjecture_errors.Count == 0)
                        {
                            // No positive or negative counter-example added. Need to add implication counter-examples
                            Debug.Assert(collector.implication_errors.Count > 0);
                            if (CommandLineOptions.Clo.RSInfer)
                            {
                                // outdated: here we are about to add an implication
                                // counterexample. Check first that if there's recurrent set, and if
                                // there's havoc in the error trace.
                                // if so, compute wlp and repeat.

                                #region  havoc_underapprox

                                // if (hasRecurrentSet && !HavocApproximated)
                                // {
                                //     foreach (var cex in collector.implication_errors)
                                //     {
                                //         AssertCounterexample assertCounterexample = cex as AssertCounterexample;
                                //         if (assertCounterexample == null)
                                //             continue;
                                //         AssertCmd failing = assertCounterexample.FailingAssert;
                                //         List<Block> trace = assertCounterexample.Trace;
                                //
                                //         bool haveHavoc = haveNondetInLoop(trace);
                                //         if (!haveHavoc)
                                //             continue;
                                //
                                //         Console.WriteLine("Havoc found. Trying to underapproximate nondeterminism in " + impl);
                                //     
                                //         NondetApproxAssumeCmd nondetCmd = null;
                                //         
                                //         // first extract functions.
                                //         FunctionCollector functionCollector = new FunctionCollector();
                                //         functionCollector.Visit(failing.Expr);
                                //         Function f = functionCollector.functionsUsed[0].Item1;
                                //         Expr starting = null;
                                //         foreach (var p in impl2FuncCalls[impl])
                                //         {
                                //             if (p.Item2 == f)
                                //             {
                                //                 starting = function2Value[p.Item1].Gamma(p.Item3.Args);
                                //                 break;
                                //             }
                                //         }
                                //
                                //         starting = Expr.Not(starting);
                                //
                                //         Expr res = computeWlpForErrorTrace(trace, starting, failing, out nondetCmd);
                                //
                                //         if (nondetCmd != null)
                                //         {
                                //             Expr newval = Expr.Not(res);
                                //             var fcollector = new FunctionCollector();
                                //             fcollector.Visit(nondetCmd);
                                //             Function func = fcollector.functionsUsed[0].Item1;
                                //             
                                //             extraFunc2Value[func.Name] = newval;
                                //             
                                //             HavocApproximated = true;
                                //             break;
                                //         }
                                //     }
                                //
                                //     if (HavocApproximated)
                                //     {
                                //         var dep = new HashSet<string>();
                                //         dep.Add(impl);
                                //         dep.Iter(s => worklist.Add(Tuple.Create(impl2Priority[s], s)));
                                //
                                //         break;
                                //     }
                                // }
                                //
                                // HavocApproximated = true;
                                #endregion
                            }

                            foreach (var cex in implicationCounterExamples)
                            {
                                AddCounterExample(cex);
                            }
                            
                            // update the iteration counter by 1
                            // note: is it possible to have multiple implication ces, leading to different
                            // violation paths?
                        }

                        //Debug.Assert(newSamplesAdded);
                        HashSet<string> funcsChanged;

                        if (!learn(out funcsChanged))
                        {
                            // learner timed out, ran into some errors, or if there is no consistent conjecture
                            // handle the error
                            if (CommandLineOptions.Clo.RSInfer && hasRecurrentSet)
                            {
                                // TODO: try to generalize the positive example (block set) here
                                // the try generate function should be updated to use the generalized example as well.
                                
                                regenerate:
                                flipAndGeneralizePositiveSample();
                                if (TryGeneratePositiveSamples())
                                {
                                    HashSet<string> changed;
                                    if (!learn(out changed))
                                    {
                                        goto regenerate;
                                    }
                                    
                                    var dep = new HashSet<string>();
                                    dep.Add(impl);
                                    changed.Iter(f => dep.UnionWith(function2implAssumed[f]));
                                    changed.Iter(f => dep.UnionWith(function2implAsserted[f]));
                                    
                                    dep.Iter(s => worklist.Add(Tuple.Create(impl2Priority[s], s)));

                                    break;
                                }
                            }
                            if(collector.conjecture_errors.Count > 0)
                                return new VCGenOutcome(ProverInterface.Outcome.Invalid, collector.conjecture_errors);
                            else
                                return new VCGenOutcome(ProverInterface.Outcome.Invalid, collector.implication_errors);
                        }
                        // propagate dependent guys back into the worklist, including self
                        var deps = new HashSet<string>();
                        deps.Add(impl);
                        funcsChanged.Iter(f => deps.UnionWith(function2implAssumed[f]));
                        funcsChanged.Iter(f => deps.UnionWith(function2implAsserted[f]));

                        deps.Iter(s => worklist.Add(Tuple.Create(impl2Priority[s], s)));

                        // break out of the loop that iterates over various bounds.
                        break;
                    }
                    else
                    {
                        if (i == bounds4cex.Count() && CommandLineOptions.Clo.RSInfer && hasRecurrentSet)
                        {
                            // then check (only at the last iteration)
                            if (CheckInstrumentedProgram())
                            {
                                // continue only the current recurrent set is invalid
                                // and a new positive example is obtained
                                HashSet<string> funcsChanged;

                                learn(out funcsChanged);
                                
                                var deps = new HashSet<string>();
                                deps.Add(impl);
                                deps.Iter(s => worklist.Add(Tuple.Create(impl2Priority[s], s)));

                                break;
                            }
                        }
                        // else: prover.Pop();
                    }
                }
            }
            
            // _ADD: generalize the recurrent set(if needed)
            if (CommandLineOptions.Clo.RSInfer && VCisValid)
            {
                C5Domain rs = function2Value["b1"] as C5Domain;
                Expr modelExpr = rs.getModelExpr();
                Console.WriteLine("[INFO] Current RS: " + modelExpr);
                
                // Expr generalizedRS = generalizeRS();
                // Expr generalizedRS = newGeneralizeRS();
                if (CommandLineOptions.Clo.RSGeneralize)
                {
                    modelExpr = modifiedGeneralizeRS_2(modelExpr);
                }
                
                // _ADD: try to infer a condition after finding the recurrent set(if needed)
                if (CommandLineOptions.Clo.ConditionInfer)
                {
                    learnCondition(modelExpr);
                }
            }
            
            // The program was verified
            return new VCGenOutcome(ProverInterface.Outcome.Valid, new List<Counterexample>());            
        }
        
        private Expr modifiedGeneralizeRS_2(Expr modelExpr)
        {
            if (modelExpr.Equals(Expr.True))
                return modelExpr;
            String impl = this.implWithRS.Name;
            String suffix = "_instrumented";
            Contract.Assert(impl.EndsWith(suffix));
            impl = impl.Substring(0, impl.Length - suffix.Length);
            C5Domain modelDomain = function2Value["b1"] as C5Domain;
            List<string> modelVars = modelDomain.getModelVars();
            
            // generalize predicates for each disjunct term
            List<NAryExpr> disjuncts = getTerms(modelExpr, "||");
            List<NAryExpr> newDisjuncts = new List<NAryExpr>(disjuncts);
            int index = 0;
            foreach (NAryExpr disjunct in disjuncts)
            {
                NAryExpr newDisjunct = disjunct;
                
                // generalize predicates
                #region vcgen
                index += 1;
                var terms = new List<Expr>();
                List<string> constants = new List<string>();
                // if (disjunct.Fun.FunctionName != "&&")  // only one atomic predicate
                // {
                //     continue;
                // }
                List<NAryExpr> curDisjuncts = new List<NAryExpr>(newDisjuncts);
                curDisjuncts.Remove(disjunct);
                Expr otherDisjuncts = Expr.False;
                foreach (var dis in curDisjuncts)
                {
                    otherDisjuncts = Expr.Or(otherDisjuncts, dis);
                }
                if (disjunct.Fun.FunctionName == "&&") // more than one atomic predicate
                {
                    // generalize the atomic predicates
                    
                    // extract each predicate
                    List<NAryExpr> predicates = getTerms(disjunct, "&&");
                    int ppp = 0;
                    Dictionary<Expr, Expr> curRSConstant2Expr = new Dictionary<Expr, Expr>();
                    foreach (NAryExpr predicate in predicates)
                    {
                        ppp += 1;
                        string constantName = "GeneralizeRSPredicate_" + index + "_" + ppp;
                        constants.Add(constantName);
                        RSConstant2GeneralizeExpr.Add(constantName, predicate);
                        Function constantBound = new Function(Token.NoToken, constantName, new List<Variable>(),
                            new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                        Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantBound), new List<Expr>());
                        curRSConstant2Expr.Add(callExpr, predicate);
                    }
                    
                    foreach (var tup in impl2FuncCalls[impl])
                    {
                        var controlVar = tup.Item2;
                        var exprVars = tup.Item3;
                        var varList = new List<Expr>();
                        exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));

                        var args = new List<Expr>();
                        controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                        List<Expr> houdiniExprs = new List<Expr>();
                        foreach (Expr callExpr in curRSConstant2Expr.Keys)
                        {
                            Expr predicateExpr = ExtendsExpr.replace(curRSConstant2Expr[callExpr], modelVars, varList);
                            Expr impExpr = Expr.Imp(callExpr, predicateExpr);
                            houdiniExprs.Add(impExpr);
                        }

                        Expr termExpr = BinaryTreeAnd(houdiniExprs, 0, houdiniExprs.Count - 1);
                        if (otherDisjuncts != Expr.False)
                        {
                            Expr disjunctExpr = ExtendsExpr.replace(otherDisjuncts, modelVars, varList);
                            termExpr = Expr.Or(termExpr, disjunctExpr);
                        }
                        // foreach (NAryExpr dis in curDisjuncts)
                        // {
                        //     Expr disjunctExpr = ExtendsExpr.replace(dis, modelVars, varList);
                        //     termExpr = Expr.Or(termExpr, disjunctExpr);
                        // }
                        Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args), termExpr);

                        if (controlVar.InParams.Count != 0)
                        {
                            term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                                new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                                term);
                        }
                        terms.Add(term);
                    }

                    foreach (var p in extraFunc2Value)
                    {
                        var f = new Function(Token.NoToken, p.Key, new List<Variable>(),
                            new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                        
                        Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(f), new List<Expr>()),
                            p.Value);
                        terms.Add(term);
                    }
                    
                    var gen = prover.VCExprGen;
                    var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
                    env.Typecheck(new TypecheckingContext((IErrorSink)null));
                    var envVC = prover.Context.BoogieExprTranslator.Translate(env);
                    var vc = gen.Implies(envVC, impl2VC[impl]);
                    
                    #endregion
                    
                    #region get unsat core
                    var handler = impl2ErrorHandler[impl].Item1;
                    var collector = new GeneralizeCheckCallBack(this, impl);
                    (handler as VCGen.ErrorReporter).callback = collector; 
                
                    VCisValid = true;
                    prover.Push();
                    prover.MinimizeUnsatCore();
                    prover.Assert(gen.Not(vc), true);
                    prover.FlushAxiomsToTheoremProver();

                    List<string> unsatCore = null;
                    try
                    {
                        unsatCore = prover.CheckAndUnsatCore(constants);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.Message);
                    }

                    // NAryExpr newDisjunct;
                    if (unsatCore != null)
                    {
                        Console.WriteLine("[Debug] predicate generalization---get unsat core: " + unsatCore.Concat(" "));
                        Expr generalizeExpr = Expr.True;
                        foreach (string RSConstant in unsatCore)
                        {
                            Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
                            generalizeExpr = Expr.And(generalizeExpr, curExpr);
                        }
                        Console.WriteLine("[INFO] Generalized Predicate: " + generalizeExpr);
                        prover.Pop();
                        newDisjunct = generalizeExpr as NAryExpr;
                        // if (newDisjunct != null)
                        // {
                        //     newDisjuncts.Remove(disjunct);
                        //     newDisjuncts.Add(newDisjunct);
                        // }
                        if (newDisjunct == null)
                        {
                            newDisjunct = disjunct;
                        }
                    }
                    else
                    {
                        newDisjunct = disjunct;
                        Console.WriteLine("[ERROR] predicate generalization---get unsat core failed.");
                        prover.Pop();
                    }
                    
                    #endregion
                }
                
                
                // generalize constant
                // get predicates and translate each to f(x) <= c
                List<NAryExpr> predicates2 = getTerms(newDisjunct, "&&");
                List<NAryExpr> unifiedPredicates = new List<NAryExpr>();
                foreach (var pred in predicates2)
                {
                    unifiedPredicates.Add(unifyPredicate(pred));
                }
                
                #region vcgen
                var terms2 = new List<Expr>();
                List<string> constants2 = new List<string>();
                List<string> hardConstants = new List<string>();
                // List<NAryExpr> curDisjuncts = new List<NAryExpr>(finalDisjuncts);
                // curDisjuncts.Remove(disjunct);
                // Expr otherDisjuncts = Expr.False;
                // foreach (var dis in curDisjuncts)
                // {
                //     otherDisjuncts = Expr.Or(otherDisjuncts, dis);
                // }

                Dictionary<Expr, Expr> curRSConstant2Expr2 = new Dictionary<Expr, Expr>();
                int pp = 0;
                foreach (NAryExpr predicate in unifiedPredicates)
                {
                    pp += 1;
                    List<Expr> intervals = generateIntervals(predicate);
                    int i = 0;
                    bool lastInterval = true;
                    intervals.Reverse();
                    foreach (Expr interval in intervals)
                    {
                        i += 1;
                        Expr curModel = Expr.Not(interval);
                        string constantName = "GeneralizeRSInterval_" + index + "_pred" + pp + "_int" + i;
                        constants2.Add(constantName);
                        RSConstant2GeneralizeExpr.Add(constantName, Expr.Not(interval));
                        Function constantBound = new Function(Token.NoToken, constantName, new List<Variable>(),
                            new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                        Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantBound), new List<Expr>());
                        curRSConstant2Expr2.Add(callExpr, Expr.Not(interval));
                        if (lastInterval)
                        {
                            terms2.Add(callExpr);
                            constants2.Remove(constantName);
                            hardConstants.Add(constantName);
                            lastInterval = false;
                        }
                    }
                }
                
                foreach (var tup in impl2FuncCalls[impl])
                {
                    var controlVar = tup.Item2;
                    var exprVars = tup.Item3;
                    var varList = new List<Expr>();
                    exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));

                    var args = new List<Expr>();
                    controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                    List<Expr> houdiniExprs = new List<Expr>();
                    foreach (Expr callExpr in curRSConstant2Expr2.Keys)
                    {
                        Expr predicateExpr = ExtendsExpr.replace(curRSConstant2Expr2[callExpr], modelVars, varList);
                        Expr impExpr = Expr.Imp(callExpr, predicateExpr);
                        houdiniExprs.Add(impExpr);
                    }

                    Expr termExpr = BinaryTreeAnd(houdiniExprs, 0, houdiniExprs.Count - 1);
                    if (otherDisjuncts != Expr.False)
                    {
                        Expr disjunctExpr = ExtendsExpr.replace(otherDisjuncts, modelVars, varList);
                        termExpr = Expr.Or(termExpr, disjunctExpr);
                    }
                    Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args), termExpr);

                    if (controlVar.InParams.Count != 0)
                    {
                        term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                            new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                            term);
                    }
                    terms2.Add(term);
                }

                foreach (var p in extraFunc2Value)
                {
                    var f = new Function(Token.NoToken, p.Key, new List<Variable>(),
                        new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                    
                    Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(f), new List<Expr>()),
                        p.Value);
                    terms2.Add(term);
                }
                
                var gen2 = prover.VCExprGen;
                var env2 = BinaryTreeAnd(terms2, 0, terms2.Count - 1);
                env2.Typecheck(new TypecheckingContext((IErrorSink)null));
                var envVC2 = prover.Context.BoogieExprTranslator.Translate(env2);
                var vc2 = gen2.Implies(envVC2, impl2VC[impl]);
                #endregion
                
                #region get unsat core
                var handler2 = impl2ErrorHandler[impl].Item1;
                var collector2 = new GeneralizeCheckCallBack(this, impl);
                (handler2 as VCGen.ErrorReporter).callback = collector2; 
            
                VCisValid = true;
                prover.Push();
                prover.MinimizeUnsatCore();
                prover.Assert(gen2.Not(vc2), true);
                prover.FlushAxiomsToTheoremProver();

                List<string> unsatCore2 = null;
                try
                {
                    unsatCore2 = prover.CheckAndUnsatCore(constants2);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }

                NAryExpr newPredicate;
                if (unsatCore2 != null)
                {
                    Console.WriteLine("[Debug] interval generalization---get unsat core: " + unsatCore2.Concat(" "));
                    unsatCore2.AddRange(hardConstants);
                }
                else
                {
                    unsatCore2 = hardConstants;
                }

                Dictionary<string, List<NAryExpr>> intervalDict = new Dictionary<string, List<NAryExpr>>();
                // Expr generalizeExpr = Expr.True;
                string pattern = @"_pred(\d+)_";
                foreach (string RSConstant in unsatCore2)
                {
                    Match match = Regex.Match(RSConstant, pattern);
                    if (match.Success)
                    {
                        string number = match.Groups[1].Value;
                        // Console.WriteLine("match pred: " + number);
                        Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
                        NAryExpr curNExpr = curExpr as NAryExpr;
                        if (curNExpr is null)
                        {
                            Console.WriteLine("[ERROR] transfer to naryexpr failed!");
                            break;
                        }
                        if (!intervalDict.ContainsKey(number))
                            intervalDict.Add(number, new List<NAryExpr>());
                        intervalDict[number].Add(curNExpr);
                    }
                    else
                    {
                        Console.WriteLine("[ERROR] match pred pattern failed!");
                    }
                }

                Expr newDisjunct2 = Expr.True;
                foreach (List<NAryExpr> genIntervals in intervalDict.Values)
                {
                    Expr generalizeExpr = newSimplifyGenIntervals(genIntervals);
                    Console.WriteLine("[INFO] Generalized Predicate: " + generalizeExpr);
                    if (generalizeExpr.Equals(Expr.False))  // necessary?
                    {
                        Console.WriteLine("[Info] get false generalizeExpr?");
                    }
                    else
                    {
                        newPredicate = generalizeExpr as NAryExpr;
                        if (newPredicate != null)
                        {
                            newDisjunct2 = Expr.And(newDisjunct2, newPredicate);
                        }
                    }
                }

                if (!newDisjunct2.Equals(Expr.True))
                {
                    // finalDisjuncts.Remove(disjunct);
                    // finalDisjuncts.Add(newDisjunct as NAryExpr);
                    newDisjuncts.Remove(disjunct);
                    newDisjuncts.Add(newDisjunct2 as NAryExpr);
                }
                prover.Pop();
                #endregion
            }
            
            // // generalize constant for each disjunct term
            // List<NAryExpr> finalDisjuncts = new List<NAryExpr>(newDisjuncts);
            // index = 0;
            // foreach (NAryExpr disjunct in newDisjuncts)
            // {
            //     index += 1;
            //     // get predicates and translate each to f(x) <= c
            //     List<NAryExpr> predicates = getTerms(disjunct, "&&");
            //     List<NAryExpr> unifiedPredicates = new List<NAryExpr>();
            //     foreach (var pred in predicates)
            //     {
            //         unifiedPredicates.Add(unifyPredicate(pred));
            //     }
            //     
            //     #region vcgen
            //     var terms = new List<Expr>();
            //     List<string> constants = new List<string>();
            //     List<string> hardConstants = new List<string>();
            //     List<NAryExpr> curDisjuncts = new List<NAryExpr>(finalDisjuncts);
            //     curDisjuncts.Remove(disjunct);
            //     Expr otherDisjuncts = Expr.False;
            //     foreach (var dis in curDisjuncts)
            //     {
            //         otherDisjuncts = Expr.Or(otherDisjuncts, dis);
            //     }
            //
            //     Dictionary<Expr, Expr> curRSConstant2Expr = new Dictionary<Expr, Expr>();
            //     int pp = 0;
            //     foreach (NAryExpr predicate in unifiedPredicates)
            //     {
            //         pp += 1;
            //         List<Expr> intervals = generateIntervals(predicate);
            //         int i = 0;
            //         bool lastInterval = true;
            //         intervals.Reverse();
            //         foreach (Expr interval in intervals)
            //         {
            //             i += 1;
            //             Expr curModel = Expr.Not(interval);
            //             // curModel = Expr.Or(curModel, otherDisjuncts);
            //             string constantName = "GeneralizeRSInterval_" + index + "_pred" + pp + "_int" + i;
            //             constants.Add(constantName);
            //             RSConstant2GeneralizeExpr.Add(constantName, Expr.Not(interval));
            //             Function constantBound = new Function(Token.NoToken, constantName, new List<Variable>(),
            //                 new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
            //             Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantBound), new List<Expr>());
            //             curRSConstant2Expr.Add(callExpr, Expr.Not(interval));
            //             // var tuple = generateConstant(impl, curModel, constantName, firstBound);
            //             // List<Expr> curTerms = tuple.Item2;
            //             if (lastInterval)
            //             {
            //                 terms.Add(callExpr);
            //                 constants.Remove(constantName);
            //                 hardConstants.Add(constantName);
            //                 lastInterval = false;
            //             }
            //             // firstBound = false;
            //             // terms.AddRange(curTerms);
            //         }
            //     }
            //     
            //     foreach (var tup in impl2FuncCalls[impl])
            //     {
            //         var controlVar = tup.Item2;
            //         var exprVars = tup.Item3;
            //         var varList = new List<Expr>();
            //         exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));
            //
            //         var args = new List<Expr>();
            //         controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
            //         List<Expr> houdiniExprs = new List<Expr>();
            //         foreach (Expr callExpr in curRSConstant2Expr.Keys)
            //         {
            //             Expr predicateExpr = ExtendsExpr.replace(curRSConstant2Expr[callExpr], modelVars, varList);
            //             Expr impExpr = Expr.Imp(callExpr, predicateExpr);
            //             houdiniExprs.Add(impExpr);
            //         }
            //
            //         Expr termExpr = BinaryTreeAnd(houdiniExprs, 0, houdiniExprs.Count - 1);
            //         if (otherDisjuncts != Expr.False)
            //         {
            //             Expr disjunctExpr = ExtendsExpr.replace(otherDisjuncts, modelVars, varList);
            //             termExpr = Expr.Or(termExpr, disjunctExpr);
            //         }
            //         Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args), termExpr);
            //
            //         if (controlVar.InParams.Count != 0)
            //         {
            //             term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
            //                 new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
            //                 term);
            //         }
            //         terms.Add(term);
            //     }
            //
            //     foreach (var p in extraFunc2Value)
            //     {
            //         var f = new Function(Token.NoToken, p.Key, new List<Variable>(),
            //             new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
            //         
            //         Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(f), new List<Expr>()),
            //             p.Value);
            //         terms.Add(term);
            //     }
            //     
            //     var gen = prover.VCExprGen;
            //     var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
            //     env.Typecheck(new TypecheckingContext((IErrorSink)null));
            //     var envVC = prover.Context.BoogieExprTranslator.Translate(env);
            //     var vc = gen.Implies(envVC, impl2VC[impl]);
            //     #endregion
            //     
            //     #region get unsat core
            //     var handler = impl2ErrorHandler[impl].Item1;
            //     var collector = new GeneralizeCheckCallBack(this, impl);
            //     (handler as VCGen.ErrorReporter).callback = collector; 
            //
            //     VCisValid = true;
            //     prover.Push();
            //     prover.MinimizeUnsatCore();
            //     prover.Assert(gen.Not(vc), true);
            //     prover.FlushAxiomsToTheoremProver();
            //
            //     List<string> unsatCore = null;
            //     try
            //     {
            //         unsatCore = prover.CheckAndUnsatCore(constants);
            //     }
            //     catch (Exception e)
            //     {
            //         Console.WriteLine(e.Message);
            //     }
            //
            //     NAryExpr newPredicate;
            //     if (unsatCore != null)
            //     {
            //         Console.WriteLine("[Debug] interval generalization---get unsat core: " + unsatCore.Concat(" "));
            //         unsatCore.AddRange(hardConstants);
            //     }
            //     else
            //     {
            //         unsatCore = hardConstants;
            //     }
            //
            //     Dictionary<string, List<NAryExpr>> intervalDict = new Dictionary<string, List<NAryExpr>>();
            //     // Expr generalizeExpr = Expr.True;
            //     string pattern = @"_pred(\d+)_";
            //     foreach (string RSConstant in unsatCore)
            //     {
            //         Match match = Regex.Match(RSConstant, pattern);
            //         if (match.Success)
            //         {
            //             string number = match.Groups[1].Value;
            //             // Console.WriteLine("match pred: " + number);
            //             Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
            //             NAryExpr curNExpr = curExpr as NAryExpr;
            //             if (curNExpr is null)
            //             {
            //                 Console.WriteLine("[ERROR] transfer to naryexpr failed!");
            //                 break;
            //             }
            //             if (!intervalDict.ContainsKey(number))
            //                 intervalDict.Add(number, new List<NAryExpr>());
            //             intervalDict[number].Add(curNExpr);
            //         }
            //         else
            //         {
            //             Console.WriteLine("[ERROR] match pred pattern failed!");
            //         }
            //     }
            //
            //     Expr newDisjunct = Expr.True;
            //     foreach (List<NAryExpr> genIntervals in intervalDict.Values)
            //     {
            //         Expr generalizeExpr = newSimplifyGenIntervals(genIntervals);
            //         Console.WriteLine("[INFO] Generalized Predicate: " + generalizeExpr);
            //         if (generalizeExpr.Equals(Expr.False))  // necessary?
            //         {
            //             Console.WriteLine("[Info] get false generalizeExpr?");
            //         }
            //         else
            //         {
            //             newPredicate = generalizeExpr as NAryExpr;
            //             if (newPredicate != null)
            //             {
            //                 newDisjunct = Expr.And(newDisjunct, newPredicate);
            //             }
            //         }
            //     }
            //
            //     if (!newDisjunct.Equals(Expr.True))
            //     {
            //         finalDisjuncts.Remove(disjunct);
            //         finalDisjuncts.Add(newDisjunct as NAryExpr);
            //     }
            //     prover.Pop();
            //     
            //     // else
            //     // {
            //     //     Console.WriteLine("[ERROR] interval generalization---get unsat core failed.");
            //     //     prover.Pop();
            //     // }
            //     #endregion
            // }

            Expr res = Expr.False;
            foreach (Expr d in newDisjuncts)
            {
                res = Expr.Or(res, d);
            }
            
            Console.WriteLine("[INFO] Generalized RS: " + res);
            return res;
        }

        private Expr modifiedGeneralizeRS(Expr modelExpr)
        {
            if (modelExpr.Equals(Expr.True))
                return modelExpr;
            String impl = this.implWithRS.Name;
            String suffix = "_instrumented";
            Contract.Assert(impl.EndsWith(suffix));
            impl = impl.Substring(0, impl.Length - suffix.Length);
            C5Domain modelDomain = function2Value["b1"] as C5Domain;
            List<string> modelVars = modelDomain.getModelVars();
            
            // generalize predicates for each disjunct term
            List<NAryExpr> disjuncts = getTerms(modelExpr, "||");
            List<NAryExpr> newDisjuncts = new List<NAryExpr>(disjuncts);
            int index = 0;
            foreach (NAryExpr disjunct in disjuncts)
            {
                #region vcgen
                index += 1;
                var terms = new List<Expr>();
                List<string> constants = new List<string>();
                if (disjunct.Fun.FunctionName != "&&")  // only one atomic predicate
                {
                    continue;
                }
                // generalize the atomic predicates
                List<NAryExpr> curDisjuncts = new List<NAryExpr>(newDisjuncts);
                curDisjuncts.Remove(disjunct);
                Expr otherDisjuncts = Expr.False;
                foreach (var dis in curDisjuncts)
                {
                    otherDisjuncts = Expr.Or(otherDisjuncts, dis);
                }
                List<NAryExpr> predicates = getTerms(disjunct, "&&");
                // extract each predicate
                int pp = 0;
                Dictionary<Expr, Expr> curRSConstant2Expr = new Dictionary<Expr, Expr>();
                foreach (NAryExpr predicate in predicates)
                {
                    pp += 1;
                    string constantName = "GeneralizeRSPredicate_" + index + "_" + pp;
                    constants.Add(constantName);
                    RSConstant2GeneralizeExpr.Add(constantName, predicate);
                    Function constantBound = new Function(Token.NoToken, constantName, new List<Variable>(),
                        new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                    Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantBound), new List<Expr>());
                    curRSConstant2Expr.Add(callExpr, predicate);
                }
                
                foreach (var tup in impl2FuncCalls[impl])
                {
                    var controlVar = tup.Item2;
                    var exprVars = tup.Item3;
                    var varList = new List<Expr>();
                    exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));

                    var args = new List<Expr>();
                    controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                    List<Expr> houdiniExprs = new List<Expr>();
                    foreach (Expr callExpr in curRSConstant2Expr.Keys)
                    {
                        Expr predicateExpr = ExtendsExpr.replace(curRSConstant2Expr[callExpr], modelVars, varList);
                        Expr impExpr = Expr.Imp(callExpr, predicateExpr);
                        houdiniExprs.Add(impExpr);
                    }

                    Expr termExpr = BinaryTreeAnd(houdiniExprs, 0, houdiniExprs.Count - 1);
                    if (otherDisjuncts != Expr.False)
                    {
                        Expr disjunctExpr = ExtendsExpr.replace(otherDisjuncts, modelVars, varList);
                        termExpr = Expr.Or(termExpr, disjunctExpr);
                    }
                    // foreach (NAryExpr dis in curDisjuncts)
                    // {
                    //     Expr disjunctExpr = ExtendsExpr.replace(dis, modelVars, varList);
                    //     termExpr = Expr.Or(termExpr, disjunctExpr);
                    // }
                    Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args), termExpr);

                    if (controlVar.InParams.Count != 0)
                    {
                        term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                            new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                            term);
                    }
                    terms.Add(term);
                }

                foreach (var p in extraFunc2Value)
                {
                    var f = new Function(Token.NoToken, p.Key, new List<Variable>(),
                        new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                    
                    Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(f), new List<Expr>()),
                        p.Value);
                    terms.Add(term);
                }
                
                var gen = prover.VCExprGen;
                var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
                env.Typecheck(new TypecheckingContext((IErrorSink)null));
                var envVC = prover.Context.BoogieExprTranslator.Translate(env);
                var vc = gen.Implies(envVC, impl2VC[impl]);
                
                #endregion
                
                #region get unsat core
                var handler = impl2ErrorHandler[impl].Item1;
                var collector = new GeneralizeCheckCallBack(this, impl);
                (handler as VCGen.ErrorReporter).callback = collector; 
            
                VCisValid = true;
                prover.Push();
                prover.MinimizeUnsatCore();
                prover.Assert(gen.Not(vc), true);
                prover.FlushAxiomsToTheoremProver();

                List<string> unsatCore = null;
                try
                {
                    unsatCore = prover.CheckAndUnsatCore(constants);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }

                NAryExpr newDisjunct;
                if (unsatCore != null)
                {
                    Console.WriteLine("[Debug] predicate generalization---get unsat core: " + unsatCore.Concat(" "));
                    Expr generalizeExpr = Expr.True;
                    foreach (string RSConstant in unsatCore)
                    {
                        Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
                        generalizeExpr = Expr.And(generalizeExpr, curExpr);
                    }
                    Console.WriteLine("[INFO] Generalized Predicate: " + generalizeExpr);
                    prover.Pop();
                    newDisjunct = generalizeExpr as NAryExpr;
                    if (newDisjunct != null)
                    {
                        newDisjuncts.Remove(disjunct);
                        newDisjuncts.Add(newDisjunct);
                    }
                }
                else
                {
                    Console.WriteLine("[ERROR] predicate generalization---get unsat core failed.");
                    prover.Pop();
                }
                
                #endregion
            }
            
            // generalize constant for each disjunct term
            List<NAryExpr> finalDisjuncts = new List<NAryExpr>(newDisjuncts);
            index = 0;
            foreach (NAryExpr disjunct in newDisjuncts)
            {
                index += 1;
                // get predicates and translate each to f(x) <= c
                List<NAryExpr> predicates = getTerms(disjunct, "&&");
                List<NAryExpr> unifiedPredicates = new List<NAryExpr>();
                foreach (var pred in predicates)
                {
                    unifiedPredicates.Add(unifyPredicate(pred));
                }
                
                #region vcgen
                var terms = new List<Expr>();
                List<string> constants = new List<string>();
                List<string> hardConstants = new List<string>();
                List<NAryExpr> curDisjuncts = new List<NAryExpr>(finalDisjuncts);
                curDisjuncts.Remove(disjunct);
                Expr otherDisjuncts = Expr.False;
                foreach (var dis in curDisjuncts)
                {
                    otherDisjuncts = Expr.Or(otherDisjuncts, dis);
                }

                Dictionary<Expr, Expr> curRSConstant2Expr = new Dictionary<Expr, Expr>();
                int pp = 0;
                foreach (NAryExpr predicate in unifiedPredicates)
                {
                    pp += 1;
                    List<Expr> intervals = generateIntervals(predicate);
                    int i = 0;
                    bool lastInterval = true;
                    intervals.Reverse();
                    foreach (Expr interval in intervals)
                    {
                        i += 1;
                        Expr curModel = Expr.Not(interval);
                        // curModel = Expr.Or(curModel, otherDisjuncts);
                        string constantName = "GeneralizeRSInterval_" + index + "_pred" + pp + "_int" + i;
                        constants.Add(constantName);
                        RSConstant2GeneralizeExpr.Add(constantName, Expr.Not(interval));
                        Function constantBound = new Function(Token.NoToken, constantName, new List<Variable>(),
                            new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                        Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantBound), new List<Expr>());
                        curRSConstant2Expr.Add(callExpr, Expr.Not(interval));
                        // var tuple = generateConstant(impl, curModel, constantName, firstBound);
                        // List<Expr> curTerms = tuple.Item2;
                        if (lastInterval)
                        {
                            terms.Add(callExpr);
                            constants.Remove(constantName);
                            hardConstants.Add(constantName);
                            lastInterval = false;
                        }
                        // firstBound = false;
                        // terms.AddRange(curTerms);
                    }
                }
                
                foreach (var tup in impl2FuncCalls[impl])
                {
                    var controlVar = tup.Item2;
                    var exprVars = tup.Item3;
                    var varList = new List<Expr>();
                    exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));

                    var args = new List<Expr>();
                    controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                    List<Expr> houdiniExprs = new List<Expr>();
                    foreach (Expr callExpr in curRSConstant2Expr.Keys)
                    {
                        Expr predicateExpr = ExtendsExpr.replace(curRSConstant2Expr[callExpr], modelVars, varList);
                        Expr impExpr = Expr.Imp(callExpr, predicateExpr);
                        houdiniExprs.Add(impExpr);
                    }

                    Expr termExpr = BinaryTreeAnd(houdiniExprs, 0, houdiniExprs.Count - 1);
                    if (otherDisjuncts != Expr.False)
                    {
                        Expr disjunctExpr = ExtendsExpr.replace(otherDisjuncts, modelVars, varList);
                        termExpr = Expr.Or(termExpr, disjunctExpr);
                    }
                    Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args), termExpr);

                    if (controlVar.InParams.Count != 0)
                    {
                        term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                            new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                            term);
                    }
                    terms.Add(term);
                }

                foreach (var p in extraFunc2Value)
                {
                    var f = new Function(Token.NoToken, p.Key, new List<Variable>(),
                        new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                    
                    Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(f), new List<Expr>()),
                        p.Value);
                    terms.Add(term);
                }
                
                var gen = prover.VCExprGen;
                var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
                env.Typecheck(new TypecheckingContext((IErrorSink)null));
                var envVC = prover.Context.BoogieExprTranslator.Translate(env);
                var vc = gen.Implies(envVC, impl2VC[impl]);
                #endregion
                
                #region get unsat core
                var handler = impl2ErrorHandler[impl].Item1;
                var collector = new GeneralizeCheckCallBack(this, impl);
                (handler as VCGen.ErrorReporter).callback = collector; 
            
                VCisValid = true;
                prover.Push();
                prover.MinimizeUnsatCore();
                prover.Assert(gen.Not(vc), true);
                prover.FlushAxiomsToTheoremProver();

                List<string> unsatCore = null;
                try
                {
                    unsatCore = prover.CheckAndUnsatCore(constants);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }

                NAryExpr newPredicate;
                if (unsatCore != null)
                {
                    Console.WriteLine("[Debug] interval generalization---get unsat core: " + unsatCore.Concat(" "));
                    unsatCore.AddRange(hardConstants);
                }
                else
                {
                    unsatCore = hardConstants;
                }

                Dictionary<string, List<NAryExpr>> intervalDict = new Dictionary<string, List<NAryExpr>>();
                // Expr generalizeExpr = Expr.True;
                string pattern = @"_pred(\d+)_";
                foreach (string RSConstant in unsatCore)
                {
                    Match match = Regex.Match(RSConstant, pattern);
                    if (match.Success)
                    {
                        string number = match.Groups[1].Value;
                        // Console.WriteLine("match pred: " + number);
                        Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
                        NAryExpr curNExpr = curExpr as NAryExpr;
                        if (curNExpr is null)
                        {
                            Console.WriteLine("[ERROR] transfer to naryexpr failed!");
                            break;
                        }
                        if (!intervalDict.ContainsKey(number))
                            intervalDict.Add(number, new List<NAryExpr>());
                        intervalDict[number].Add(curNExpr);
                    }
                    else
                    {
                        Console.WriteLine("[ERROR] match pred pattern failed!");
                    }
                }

                Expr newDisjunct = Expr.True;
                foreach (List<NAryExpr> genIntervals in intervalDict.Values)
                {
                    Expr generalizeExpr = newSimplifyGenIntervals(genIntervals);
                    Console.WriteLine("[INFO] Generalized Predicate: " + generalizeExpr);
                    if (generalizeExpr.Equals(Expr.False))  // necessary?
                    {
                        Console.WriteLine("[Info] get false generalizeExpr?");
                    }
                    else
                    {
                        newPredicate = generalizeExpr as NAryExpr;
                        if (newPredicate != null)
                        {
                            newDisjunct = Expr.And(newDisjunct, newPredicate);
                        }
                    }
                }

                if (!newDisjunct.Equals(Expr.True))
                {
                    finalDisjuncts.Remove(disjunct);
                    finalDisjuncts.Add(newDisjunct as NAryExpr);
                }
                prover.Pop();
                
                // else
                // {
                //     Console.WriteLine("[ERROR] interval generalization---get unsat core failed.");
                //     prover.Pop();
                // }
                #endregion
            }

            Expr res = Expr.False;
            foreach (Expr d in finalDisjuncts)
            {
                res = Expr.Or(res, d);
            }
            
            Console.WriteLine("[INFO] Generalized RS: " + res);
            return res;
        }

        private Expr newGeneralizeRS()
        {
            // get current rs model expr
            C5Domain rs = function2Value["b1"] as C5Domain;
            Expr modelExpr = rs.getModelExpr();
            Console.WriteLine("[INFO] Current RS: " + modelExpr);
            if (modelExpr.Equals(Expr.True))
                return modelExpr;
            
            String impl = this.implWithRS.Name;
            String suffix = "_instrumented";
            Contract.Assert(impl.EndsWith(suffix));
            impl = impl.Substring(0, impl.Length - suffix.Length);
            
            // generalize predicates for each disjunct term
            List<NAryExpr> disjuncts = getTerms(modelExpr, "||");
            List<NAryExpr> newDisjuncts = new List<NAryExpr>(disjuncts);
            int index = 0;
            bool firstBound = true;
            foreach (NAryExpr disjunct in disjuncts)
            {
                #region vcgen
                index += 1;
                var terms = new List<Expr>();
                List<string> constants = new List<string>();
                if (disjunct.Fun.FunctionName != "&&")  // only one atomic predicate
                {
                    continue;
                }
                // generalize the atomic predicates
                List<NAryExpr> curDisjuncts = new List<NAryExpr>(newDisjuncts);
                curDisjuncts.Remove(disjunct);
                List<NAryExpr> predicates = getTerms(disjunct, "&&");
                // generate expr constant for each predicate
                int p = 0;
                foreach (NAryExpr predicate in predicates)
                {
                    p += 1;
                    Expr curModel = predicate;
                    foreach (NAryExpr dis in curDisjuncts)
                    {
                        curModel = Expr.Or(curModel, dis);
                    }

                    string constantName = "GeneralizeRSPredicate_" + index + "_" + p;
                    constants.Add(constantName);
                    RSConstant2GeneralizeExpr.Add(constantName, predicate);
                    List<Expr> curTerms = generateConstant(impl, curModel, constantName, firstBound).Item2;
                    firstBound = false;
                    terms.AddRange(curTerms);
                }
                #endregion
                
                #region get unsat core
                var gen = prover.VCExprGen;
                var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
                env.Typecheck(new TypecheckingContext((IErrorSink)null));
                var envVC = prover.Context.BoogieExprTranslator.Translate(env);
                var vc = gen.Implies(envVC, impl2VC[impl]);
                
                var handler = impl2ErrorHandler[impl].Item1;
                var collector = new GeneralizeCheckCallBack(this, impl);
                (handler as VCGen.ErrorReporter).callback = collector; 
            
                VCisValid = true;
                prover.Push();
                prover.MinimizeUnsatCore();
                prover.Assert(gen.Not(vc), true);
                prover.FlushAxiomsToTheoremProver();

                List<string> unsatCore = null;
                try
                {
                    unsatCore = prover.CheckAndUnsatCore(constants);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }

                NAryExpr newDisjunct;
                if (unsatCore != null)
                {
                    Console.WriteLine("[Debug] predicate generalization---get unsat core: " + unsatCore.Concat(" "));
                    Expr generalizeExpr = Expr.True;
                    foreach (string RSConstant in unsatCore)
                    {
                        Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
                        generalizeExpr = Expr.And(generalizeExpr, curExpr);
                    }
                    Console.WriteLine("[INFO] Generalized Predicate: " + generalizeExpr);
                    prover.Pop();
                    newDisjunct = generalizeExpr as NAryExpr;
                    if (newDisjunct != null)
                    {
                        newDisjuncts.Remove(disjunct);
                        newDisjuncts.Add(newDisjunct);
                    }
                }
                else
                {
                    Console.WriteLine("[ERROR] predicate generalization---get unsat core failed.");
                    prover.Pop();
                }
                
                #endregion
            }
            
            // generalize constant for each disjunct term
            List<NAryExpr> finalDisjuncts = new List<NAryExpr>(newDisjuncts);
            index = 0;
            firstBound = true;
            foreach (NAryExpr disjunct in newDisjuncts)
            {
                index += 1;
                // get predicates and translate each to f(x) <= c
                List<NAryExpr> predicates = getTerms(disjunct, "&&");
                List<NAryExpr> unifiedPredicates = new List<NAryExpr>();
                foreach (var pred in predicates)
                {
                    unifiedPredicates.Add(unifyPredicate(pred));
                }
                
                #region vcgen
                var terms = new List<Expr>();
                List<string> constants = new List<string>();
                List<string> hardConstants = new List<string>();
                List<NAryExpr> curDisjuncts = new List<NAryExpr>(finalDisjuncts);
                curDisjuncts.Remove(disjunct);
                Expr otherDisjuncts = Expr.False;
                foreach (var dis in curDisjuncts)
                {
                    otherDisjuncts = Expr.Or(otherDisjuncts, dis);
                }
                int p = 0;
                foreach (NAryExpr predicate in unifiedPredicates)
                {
                    
                    p += 1;
                    List<Expr> intervals = generateIntervals(predicate);
                    int i = 0;
                    bool lastInterval = true;
                    intervals.Reverse();
                    foreach (Expr interval in intervals)
                    {
                        i += 1;
                        Expr curModel = Expr.Not(interval);
                        curModel = Expr.Or(curModel, otherDisjuncts);
                        string constantName = "GeneralizeRSInterval_" + index + "_pred" + p + "_int" + i;
                        constants.Add(constantName);
                        RSConstant2GeneralizeExpr.Add(constantName, Expr.Not(interval));
                        var tuple = generateConstant(impl, curModel, constantName, firstBound);
                        List<Expr> curTerms = tuple.Item2;
                        if (lastInterval)
                        {
                            terms.Add(tuple.Item1);
                            constants.Remove(constantName);
                            hardConstants.Add(constantName);
                            lastInterval = false;
                        }
                        firstBound = false;
                        terms.AddRange(curTerms);
                    }
                }
                #endregion
                
                #region get unsat core
                var gen = prover.VCExprGen;
                var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
                env.Typecheck(new TypecheckingContext((IErrorSink)null));
                var envVC = prover.Context.BoogieExprTranslator.Translate(env);
                var vc = gen.Implies(envVC, impl2VC[impl]);
                
                var handler = impl2ErrorHandler[impl].Item1;
                var collector = new GeneralizeCheckCallBack(this, impl);
                (handler as VCGen.ErrorReporter).callback = collector; 
            
                VCisValid = true;
                prover.Push();
                prover.MinimizeUnsatCore();
                prover.Assert(gen.Not(vc), true);
                prover.FlushAxiomsToTheoremProver();

                List<string> unsatCore = null;
                try
                {
                    unsatCore = prover.CheckAndUnsatCore(constants);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }

                NAryExpr newPredicate;
                if (unsatCore != null)
                {
                    Console.WriteLine("[Debug] interval generalization---get unsat core: " + unsatCore.Concat(" "));
                    unsatCore.AddRange(hardConstants);
                    // List<NAryExpr> genIntervals = new List<NAryExpr>();
                    Dictionary<string, List<NAryExpr>> intervalDict = new Dictionary<string, List<NAryExpr>>();
                    // Expr generalizeExpr = Expr.True;
                    string pattern = @"_pred(\d+)_";
                    foreach (string RSConstant in unsatCore)
                    {
                        Match match = Regex.Match(RSConstant, pattern);
                        if (match.Success)
                        {
                            string number = match.Groups[1].Value;
                            // Console.WriteLine("match pred: " + number);
                            Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
                            NAryExpr curNExpr = curExpr as NAryExpr;
                            if (curNExpr is null)
                            {
                                Console.WriteLine("[ERROR] transfer to naryexpr failed!");
                                break;
                            }
                            if (!intervalDict.ContainsKey(number))
                                intervalDict.Add(number, new List<NAryExpr>());
                            intervalDict[number].Add(curNExpr);
                        }
                        else
                        {
                            Console.WriteLine("[ERROR] match pred pattern failed!");
                        }
                        // Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
                        // NAryExpr curNExpr = curExpr as NAryExpr;
                        // if (curNExpr is null)
                        // {
                        //     Console.WriteLine("[ERROR] transfer to naryexpr failed!");
                        //     break;
                        // }
                        // genIntervals.Add(curNExpr);
                        // // generalizeExpr = Expr.And(generalizeExpr, curExpr);
                    }

                    Expr newDisjunct = Expr.True;
                    foreach (List<NAryExpr> genIntervals in intervalDict.Values)
                    {
                        // Expr generalizeExpr = simplifyGenIntervals(genIntervals);
                        Expr generalizeExpr = newSimplifyGenIntervals(genIntervals);
                        Console.WriteLine("[INFO] Generalized Predicate: " + generalizeExpr);
                        if (generalizeExpr.Equals(Expr.False))  // necessary?
                        {
                            Console.WriteLine("[Info] get false generalizeExpr?");
                        }
                        else
                        {
                            newPredicate = generalizeExpr as NAryExpr;
                            if (newPredicate != null)
                            {
                                newDisjunct = Expr.And(newDisjunct, newPredicate);
                            }
                        }
                    }

                    if (!newDisjunct.Equals(Expr.True))
                    {
                        finalDisjuncts.Remove(disjunct);
                        finalDisjuncts.Add(newDisjunct as NAryExpr);
                    }

                    // Expr generalizeExpr = simplifyGenIntervals(genIntervals);
                    // Console.WriteLine("[INFO] Generalized Predicate: " + generalizeExpr);
                    prover.Pop();
                    // if (generalizeExpr.Equals(Expr.False))  // necessary?
                    // {
                    //     // finalDisjuncts.Remove(disjunct);
                    //     Console.WriteLine("[Info] get false generalizeExpr?");
                    // }
                    // else
                    // {
                    //     newDisjunct = generalizeExpr as NAryExpr;
                    //     if (newDisjunct != null)
                    //     {
                    //         finalDisjuncts.Remove(disjunct);
                    //         finalDisjuncts.Add(newDisjunct);
                    //     }
                    // }
                }
                else
                {
                    Console.WriteLine("[ERROR] interval generalization---get unsat core failed.");
                    prover.Pop();
                }
                #endregion
            }

            Expr res = Expr.False;
            foreach (Expr d in finalDisjuncts)
            {
                res = Expr.Or(res, d);
            }
            
            Console.WriteLine("[INFO] Generalized RS: " + res);
            return res;
        }

        private List<NAryExpr> getTerms(Expr expr, String opName)
        {
            List<NAryExpr> res = new List<NAryExpr>();
            NAryExpr nAryExpr = expr as NAryExpr;
            if (nAryExpr == null)
                return res;
            if (nAryExpr.Fun.FunctionName.Equals(opName))
            {
                res.AddRange(getTerms(nAryExpr.Args[0], opName));
                res.AddRange(getTerms(nAryExpr.Args[1], opName));
            }
            else
            {
                res.Add(nAryExpr);
            }

            return res;
        }


        // generate constant(for soft constraint) for a model expr
        private Tuple<Expr, List<Expr>> generateConstant(string impl, Expr modelExpr, string constantName, bool firstBound)
        {
            C5Domain modelDomain = function2Value["b1"] as C5Domain;
            List<string> modelVars = modelDomain.getModelVars();
            var terms = new List<Expr>();
            
            Function constantBound = new Function(Token.NoToken, constantName, new List<Variable>(),
                new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
            // RSConstant2GeneralizeExpr.Add(constantBound.Name, modelExpr);  
            Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantBound), new List<Expr>());
            List<Expr> houdiniExprs = new List<Expr>();
            foreach (var tup in impl2FuncCalls[impl])
            {
                var controlVar = tup.Item2;
                var exprVars = tup.Item3;
                var varList = new List<Expr>();
                exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));
                
                var args = new List<Expr>();
                controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                
                Expr controlVarExpr = new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args);
                
                Expr term;
                if (functionForRecurrentSet.Contains(tup.Item1))
                {
                    Expr predicateExpr = ExtendsExpr.replace(modelExpr, modelVars, varList);
                    Expr impExpr1 = Expr.Imp(controlVarExpr, predicateExpr);
                    houdiniExprs.Add(impExpr1);
                    Expr impExpr2 = Expr.Imp(predicateExpr, controlVarExpr);
                    houdiniExprs.Add(impExpr2);
                }
                else if (firstBound)
                {
                    term = (function2Value[tup.Item1].Gamma(varList));
                    term = Expr.Eq(controlVarExpr, term);
                    if (controlVar.InParams.Count != 0)
                    {
                        term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                            new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                            term);
                    }
                    terms.Add(term);
                }
            }
            if (houdiniExprs.Count > 0)
            {
                Expr andExpr = BinaryTreeAnd(houdiniExprs, 0, houdiniExprs.Count - 1);
                Expr impExpr = Expr.Imp(callExpr, andExpr);
                terms.Add(impExpr);
            }

            return new Tuple<Expr, List<Expr>>(callExpr, terms);
        }


        // unify an atomic predicate to the form f(x) <= c
        private NAryExpr unifyPredicate(NAryExpr p)
        {
            string opName = p.Fun.FunctionName;
            List<Expr> exprArgs = new List<Expr>(p.Args);
            // tranfer literalexpr to the right
            if (exprArgs[0] is LiteralExpr)
            {
                var tmp = exprArgs[0];
                exprArgs[0] = exprArgs[1];
                exprArgs[1] = tmp;
                switch (opName)
                {
                    case "<=":
                        opName = ">=";
                        break;
                    case ">=":
                        opName = "<=";
                        break;
                    case "<":
                        opName = ">";
                        break;
                    case ">":
                        opName = "<";
                        break;
                    default: break;
                }
            }
            // unify the form
            if (exprArgs[1] is LiteralExpr)
            {
                if (opName.Equals("<="))
                    return p;
                LiteralExpr rhsExpr = exprArgs[1] as LiteralExpr;
                int rhs = rhsExpr.asBigNum.ToIntSafe;
                Expr lhsExpr = exprArgs[0];
                if (opName.Equals("<"))  // transfer x<d to x<=d-1
                {
                    return Expr.Le(lhsExpr, Expr.Literal(rhs - 1));
                }
                if (opName.Equals(">="))  // transfer x>=d to -x<=-d
                {
                    // Expr newLhs = Expr.Sub(Expr.Literal(0), lhsExpr);
                    Expr newLhs = Expr.Unary(Token.NoToken, UnaryOperator.Opcode.Neg, lhsExpr);
                    return Expr.Le(newLhs, Expr.Literal(-rhs));
                }
                if (opName.Equals(">"))  // transger x>d to -x<-d to -x<=-d-1
                {
                    // Expr newLhs = Expr.Sub(Expr.Literal(0), lhsExpr);
                    Expr newLhs = Expr.Unary(Token.NoToken, UnaryOperator.Opcode.Neg, lhsExpr);
                    return Expr.Le(newLhs, Expr.Literal(-rhs-1));
                }
                else
                {
                    Console.WriteLine("[Info] Unify atomic predicate failed: incorrect form.");
                    return p;
                }
            }
            else
            {
                Console.WriteLine("[Info] Unify atomic predicate failed: incorrect form.");
                return p;
            }
        }


        // generate intervals for atomic predicate f(x)<=c
            // intervals are: f(x)<=c, f(x)>c+d_{k-1} && f(x)<=c+d_k (1<=k<=n), f(x)>c+d_n
        private List<Expr> generateIntervals(NAryExpr p)
        {
            List<Expr> res = new List<Expr>();
            int index = 0;
            List<Expr> exprArgs = p.Args;
            Expr lhsExpr = exprArgs[0];
            LiteralExpr rhsExpr = exprArgs[1] as LiteralExpr;
            int rhs = rhsExpr.asBigNum.ToIntSafe;
            int lastBound = 0;
            foreach (var bound in boundForRSGeneralization)
            {
                index += 1;
                if (index == 1)  // first bound: f(x)<=c, cancel first bound
                {
                    // res.Add(p);
                    continue;
                }
                
                // middle interval: f(x)>c+d_{k-1} && f(x)<=c+d_k
                Expr expr1 = Expr.Gt(lhsExpr, Expr.Literal(rhs + lastBound));
                Expr expr2 = Expr.Le(lhsExpr, Expr.Literal(rhs + bound));
                res.Add(Expr.And(expr1, expr2));
                lastBound = bound;
                
                if (index == boundForRSGeneralization.Count)  // last bound: f(x)>c+d_n
                {
                    res.Add(Expr.Gt(lhsExpr, Expr.Literal(rhs+bound)));
                }
            }

            return res;
        }


        // get the smallest constant and return f(x) <= c
        private Expr newSimplifyGenIntervals(List<NAryExpr> intervals)
        {
            // get variable expr
            NAryExpr nAryExpr = intervals.First();
            while (nAryExpr.Fun.FunctionName == "!" || nAryExpr.Fun.FunctionName == "&&" || nAryExpr.Fun.FunctionName == "||")
            {
                nAryExpr = nAryExpr.Args[0] as NAryExpr;
            }
            Expr varExpr = nAryExpr.Args[0];
            if (nAryExpr.Args[0] is LiteralExpr)
                varExpr = nAryExpr.Args[1];
            else if (nAryExpr.Args[1] is LiteralExpr)
                varExpr = nAryExpr.Args[0];
            
            // get the smallest constant
            int constant = 1000000;
            foreach (NAryExpr interval in intervals)
            {
                int c = getConstant(interval);
                constant = Math.Min(constant, c);
            }
            
            // return f(x)<=c
            return Expr.Le(varExpr, Expr.Literal(constant));
        }


        private int getConstant(NAryExpr expr)
        {
            string opName = expr.Fun.FunctionName;
            if (opName == "!")
                return getConstant(expr.Args[0] as NAryExpr);
            if (opName == "&&" || opName == "||")
            {
                int c1 = getConstant(expr.Args[0] as NAryExpr);
                int c2 = getConstant(expr.Args[1] as NAryExpr);
                return Math.Min(c1, c2);
            }

            if (expr.Args[0] is LiteralExpr)
            {
                LiteralExpr constantExpr = expr.Args[0] as LiteralExpr;
                int c = constantExpr.asBigNum.ToIntSafe;
                return c;
            }
            if (expr.Args[1] is LiteralExpr)
            {
                LiteralExpr constantExpr = expr.Args[1] as LiteralExpr;
                int c = constantExpr.asBigNum.ToIntSafe;
                return c;
            }

            return 1000000;
        }
        

        // simplify conjunction of generalized intervals to a DNF formula
        private Expr simplifyGenIntervals(List<NAryExpr> intervals)
        {
            Expr res = Expr.False;
            if (intervals.Count == 1)
            {
                NAryExpr expr = intervals.First();
                List<Expr> ints = simplifySingleInterval(expr);
                
                foreach (var dis in ints)
                {
                    res = Expr.Or(res, dis);
                }
                return res;
            }

            List<List<Expr>> conjuncts = new List<List<Expr>>();
            foreach (NAryExpr expr in intervals)
            {
                List<Expr> disjuncts = simplifySingleInterval(expr);  // a1 or a2
                conjuncts.Add(disjuncts);
            }
            
            // get variable expr
            NAryExpr nAryExpr = conjuncts.First().First() as NAryExpr;
            Expr varExpr = nAryExpr.Args[0];
            if (nAryExpr.Args[0] is LiteralExpr)
                varExpr = nAryExpr.Args[1];
            else if (nAryExpr.Args[1] is LiteralExpr)
                varExpr = nAryExpr.Args[0];
                
            List<Interval> resInts = binaryCnf2Dnf(conjuncts);
            foreach (var interval in resInts)
            {
                Expr dis = Expr.True;
                if (interval.leftbound != -1000000)
                {
                    Expr geExpr = Expr.Ge(varExpr, Expr.Literal(interval.leftbound));
                    dis = Expr.And(dis, geExpr);
                }

                if (interval.rightbound != 1000000)
                {
                    Expr leExpr = Expr.Le(varExpr, Expr.Literal(interval.rightbound));
                    dis = Expr.And(dis, leExpr);
                }
                
                res = Expr.Or(res, dis);
            }
            return res;
        }


        private List<Expr> simplifySingleInterval(NAryExpr expr)
        {
            List<Expr> res = new List<Expr>();
            string opName = expr.Fun.FunctionName;
            if (opName == "!")
            {
                NAryExpr negExpr = expr.Args.First() as NAryExpr;
                var negArgs = negExpr.Args;
                NAryExpr arg1 = negArgs[0] as NAryExpr;
                NAryExpr arg2 = negArgs[1] as NAryExpr;
                if (arg1.Fun.FunctionName == ">")
                {
                    var neg1 = Expr.Le(arg1.Args[0], arg1.Args[1]);
                    var neg2 = Expr.Gt(arg2.Args[0], arg2.Args[1]);
                    res.Add(neg1);
                    res.Add(neg2);
                    return res;
                    // return Expr.Or(neg1, neg2);
                }
                else
                {
                    var neg1 = Expr.Gt(arg1.Args[0], arg1.Args[1]);
                    var neg2 = Expr.Le(arg2.Args[0], arg2.Args[1]);
                    res.Add(neg1);
                    res.Add(neg2);
                    return res;
                    // return Expr.Or(neg1, neg2);
                }
            }
            else
            {
                res.Add(expr);
                return res;
                // return expr;
            }
        }

        
        private List<Interval> binaryCnf2Dnf(List<List<Expr>> conjuncts)
        {
            // List<Expr> res = new List<Expr>();  // all disjuncts of DNF
            List<Interval> resI = new List<Interval>();
            bool firstRound = true;
            foreach (var disjuncts in conjuncts)
            {
                if (firstRound)
                {
                    // res = new List<Expr>(disjuncts);
                    foreach (var expr in disjuncts)
                    {
                        Interval i = resolveInterval(expr);
                        if (i != null)
                            resI.Add(i);
                        else
                            Console.WriteLine("[ERROR] resolve interval failed!");
                    }
                    firstRound = false;
                    continue;
                }

                // List<Expr> newRes = new List<Expr>();
                List<Interval> newResI = new List<Interval>();
                foreach (var newExpr in disjuncts)
                {
                    foreach (var interval in resI)
                    {
                        // Expr andExpr = Expr.And(expr, newExpr);
                        Interval newI = mergeInterval(interval, newExpr);
                        if (newI != null)
                            newResI.Add(newI);
                        // if (!andExpr.Equals(Expr.False))
                        //     newRes.Add(andExpr);
                    }
                }

                // res = newRes;
                resI = newResI;
            }
            
            return resI;
        }


        // resolve the interval of a single inequality
        private Interval resolveInterval(Expr expr)
        {
            NAryExpr naryExpr = expr as NAryExpr;
            if (naryExpr == null)
            {
                return null;
            }
            
            string opName = naryExpr.Fun.FunctionName;
            List<Expr> exprArgs = new List<Expr>(naryExpr.Args);
            // LiteralExpr arg1 = exprArgs[0] as LiteralExpr;
            // LiteralExpr arg2 = exprArgs[1] as LiteralExpr;
            // if (arg1 == null && arg2 == null)
            //     return null;
            if (!(exprArgs[0] is LiteralExpr) && !(exprArgs[1] is LiteralExpr))
            {
                return null;
            }
            if (exprArgs[0] is LiteralExpr)  // transfer the constant to the right
            {
                var tmp = exprArgs[0];
                exprArgs[0] = exprArgs[1];
                exprArgs[1] = tmp;
                switch (opName)
                {
                    case "<=":
                    {
                        opName = ">=";
                        break;
                    }
                    case "<":
                    {
                        opName = ">";
                        break;
                    }
                    case ">=":
                    {
                        opName = "<=";
                        break;
                    }
                    case ">":
                    {
                        opName = "<";
                        break;
                    }
                    default: break;
                }
            }

            if (exprArgs[1] is LiteralExpr)
            {
                LiteralExpr constantExpr = exprArgs[1] as LiteralExpr;
                int constant = constantExpr.asBigNum.ToIntSafe;
                int leftbound = -1000000;
                int rightbound = 1000000;
                switch (opName)
                {
                    case "<=":
                        rightbound = Math.Min(rightbound, constant);
                        break;
                    case "<":
                        rightbound = Math.Min(rightbound, constant - 1);
                        break;
                    case ">=":
                        leftbound = Math.Max(leftbound, constant);
                        break;
                    case ">":
                        leftbound = Math.Max(leftbound, constant + 1);
                        break;
                    
                    default: break;
                }
                return new Interval(leftbound, rightbound);
            }
            return null;
        }


        private Interval mergeInterval(Interval interval, Expr expr)
        {
            Interval intb = resolveInterval(expr);
            if (intb == null)
            {
                Console.WriteLine("[ERROR] resolve interval failed!");
                return null;
            }
            if ((interval.leftbound > intb.rightbound) || (intb.leftbound > interval.rightbound))
                return null;
            int l = Math.Max(interval.leftbound, intb.leftbound);
            int r = Math.Min(interval.rightbound, intb.rightbound);
            return new Interval(l, r);

            // old version
            // NAryExpr exprA = a as NAryExpr;
            // NAryExpr exprB = expr as NAryExpr;
            //
            // string opA = exprA.Fun.FunctionName;
            // string opB = exprB.Fun.FunctionName;
            // List<Expr> argsA = new List<Expr>(exprA.Args);
            // List<Expr> argsB = new List<Expr>(exprB.Args);
            // int leftboundA = -1000000;
            // int rightboundA = 1000000;
            // int leftboundB = -1000000;
            // int rightboundB = 1000000;
            //
            // // move variable to the left for convenience
            // if (argsA[0] is LiteralExpr)
            // {
            //     var tmp = argsA[0];
            //     argsA[0] = argsA[1];
            //     argsA[1] = tmp;
            //     switch (opA)
            //     {
            //         case "<=":
            //             opA = ">=";
            //             break;
            //         case ">=":
            //             opA = "<=";
            //             break;
            //         case "<":
            //             opA = ">";
            //             break;
            //         case ">":
            //             opA = "<";
            //             break;
            //         default: break;
            //     }
            // }
            // if (argsB[0] is LiteralExpr)
            // {
            //     var tmp = argsB[0];
            //     argsB[0] = argsB[1];
            //     argsB[1] = tmp;
            //     switch (opB)
            //     {
            //         case "<=":
            //             opB = ">=";
            //             break;
            //         case ">=":
            //             opB = "<=";
            //             break;
            //         case "<":
            //             opB = ">";
            //             break;
            //         case ">":
            //             opB = "<";
            //             break;
            //         default: break;
            //     }
            // }
            //
            // // resolve two intervals
            // LiteralExpr boundAExp = argsA[1] as LiteralExpr;
            // int boundA = boundAExp.asBigNum.ToIntSafe;
            // LiteralExpr boundBExp = argsB[1] as LiteralExpr;
            // int boundB = boundBExp.asBigNum.ToIntSafe;
            // switch (opA)
            // {
            //     case "<=":
            //         rightboundA = boundA;
            //         break;
            //     case ">=":
            //         leftboundA = boundA;
            //         break;
            //     case "<":
            //         rightboundA = boundA - 1;
            //         break;
            //     case ">":
            //         leftboundA = boundA + 1;
            //         break;
            //     default: break;
            // }
            // switch (opB)
            // {
            //     case "<=":
            //         rightboundB = boundB;
            //         break;
            //     case ">=":
            //         leftboundB = boundB;
            //         break;
            //     case "<":
            //         rightboundB = boundB - 1;
            //         break;
            //     case ">":
            //         leftboundB = boundB + 1;
            //         break;
            //     default: break;
            // }
            //
            // // merge two intervals
            // if ((leftboundB > rightboundA) || (leftboundA > rightboundB))  // the intersection is empty
            // {
            //     return Expr.False;
            // }
            //
            // Expr varExpr = argsA[0];
            // int leftbound = Math.Max(leftboundA, leftboundB);
            // int rightbound = Math.Min(rightboundA, rightboundB);
            // Expr res = Expr.True;
            // if (leftbound != -1000000)
            // {
            //     res = Expr.And(res, Expr.Ge(varExpr, Expr.Literal(leftbound)));
            // }
            //
            // if (rightbound != 1000000)
            // {
            //     res = Expr.And(res, Expr.Le(varExpr, Expr.Literal(rightbound)));
            // }
            //
            // return res;
        }
        
        
        // generalize single disjunct, which is several conjuncts of atomic predicate
        private Expr generalizeSingleDisjunct(NAryExpr expr)
        {
            // predicate generalization
                // get atomic predicates
            List<NAryExpr> predicates = getTerms(expr, "&&");

            Expr simplifiedPredicatesExpr = generalizePredicates(predicates);

            return null;
        }


        private Expr generalizePredicates(List<NAryExpr> predicates)
        {
            C5Domain modelDomain = function2Value["b1"] as C5Domain;
            List<string> modelVars = modelDomain.getModelVars();
            
            String impl = this.implWithRS.Name;
            String suffix = "_instrumented";
            Contract.Assert(impl.EndsWith(suffix));
            impl = impl.Substring(0, impl.Length - suffix.Length);
            
            #region vcgen
            
            var gen = prover.VCExprGen;
            var terms = new List<Expr>();
            List<string> constants = new List<string>();
            int index = 0;
            bool firstBound = true;
            foreach (var predicate in predicates)
            {
                index += 1;
                var constantBound = new Function(Token.NoToken, "GeneralizeRSPredicate_" + index, new List<Variable>(),
                    new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                constants.Add(constantBound.Name);
                RSConstant2GeneralizeExpr.Add(constantBound.Name, predicate);
                Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantBound), new List<Expr>());
                List<Expr> houdiniExprs = new List<Expr>();
                foreach (var tup in impl2FuncCalls[impl])
                {
                    var controlVar = tup.Item2;
                    var exprVars = tup.Item3;
                    var varList = new List<Expr>();
                    exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));
                    
                    var args = new List<Expr>();
                    controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                    
                    Expr controlVarExpr = new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args);
                    
                    Expr term;
                    if (functionForRecurrentSet.Contains(tup.Item1))
                    {
                        Expr predicateExpr = ExtendsExpr.replace(predicate, modelVars, varList);
                        Expr impExpr1 = Expr.Imp(controlVarExpr, predicateExpr);
                        houdiniExprs.Add(impExpr1);
                        Expr impExpr2 = Expr.Imp(predicateExpr, controlVarExpr);
                        houdiniExprs.Add(impExpr2);
                    }
                    else if (firstBound)
                    {
                        term = (function2Value[tup.Item1].Gamma(varList));
                        term = Expr.Eq(controlVarExpr, term);
                        if (controlVar.InParams.Count != 0)
                        {
                            term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                                new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                                term);
                        }
                        terms.Add(term);
                    }
                }
                firstBound = false;
                if (houdiniExprs.Count > 0)
                {
                    Expr andExpr = BinaryTreeAnd(houdiniExprs, 0, houdiniExprs.Count - 1);
                    Expr impExpr = Expr.Imp(callExpr, andExpr);
                    terms.Add(impExpr);
                }
            }
            
            var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
            env.Typecheck(new TypecheckingContext((IErrorSink)null));
            var envVC = prover.Context.BoogieExprTranslator.Translate(env);
            var vc = gen.Implies(envVC, impl2VC[impl]);
            
            #endregion
            
            var handler = impl2ErrorHandler[impl].Item1;
            var collector = new GeneralizeCheckCallBack(this, impl);
            (handler as VCGen.ErrorReporter).callback = collector; 
            
            VCisValid = true;
            prover.Push();
            prover.MinimizeUnsatCore();
            prover.Assert(gen.Not(vc), true);
            prover.FlushAxiomsToTheoremProver();

            List<string> unsatCore = null;
            try
            {
                unsatCore = prover.CheckAndUnsatCore(constants);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            if (unsatCore != null)
            {
                Console.WriteLine("[Debug] predicate generalization---get unsat core: " + unsatCore.Concat(" "));
                Expr generalizeExpr = Expr.True;
                foreach (string RSConstant in unsatCore)
                {
                    Expr curExpr = RSConstant2GeneralizeExpr[RSConstant];
                    generalizeExpr = Expr.And(generalizeExpr, curExpr);
                }
                Console.WriteLine("[INFO] RS after predicate generalization: " + generalizeExpr);
                prover.Pop();
                return generalizeExpr;
            }
            else
            {
                Console.WriteLine("[INFO] predicate generalization---get unsat core failed.");
                prover.Pop();
                return null;
            }
        }
        
        
        private Expr generalizeRS()
        {
            String impl = this.implWithRS.Name;
            String suffix = "_instrumented";
            Contract.Assert(impl.EndsWith(suffix));
            impl = impl.Substring(0, impl.Length - suffix.Length);
            
            #region vcgen

            var gen = prover.VCExprGen;
            var terms = new List<Expr>();
            List<string> constants = new List<string>();
            bool printRS = true;
            // IEnumerable<string> tmpConstants;
            // HashSet<Function> boolConstants = new HashSet<Function>();
            bool firstBound = true;
            foreach (var bound in boundForRSGeneralization)
            {
                bool record = true;
                var constantBound = new Function(Token.NoToken, "GeneralizeRSConstant_" + bound, new List<Variable>(),
                    new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                // boolConstants.Add(constantBound);
                constants.Add(constantBound.Name);

                Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantBound), new List<Expr>());
                List<Expr> houdiniExprs = new List<Expr>();
                // Expr andExpr = Expr.True;
                // bool generalized = false;
                foreach (var tup in impl2FuncCalls[impl])
                {
                    var controlVar = tup.Item2;
                    var exprVars = tup.Item3;
                    var varList = new List<Expr>();
                    exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));
                    
                    var args = new List<Expr>();
                    controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                    
                    Expr controlVarExpr = new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args);
                    // terms.Add(controlVarExpr);
                    
                    Expr term;
                    if (functionForRecurrentSet.Contains(tup.Item1))
                    {
                        // generalize R(X)
                        Expr modelExpr = (function2Value[tup.Item1].Gamma(varList));
                        if (printRS)
                        {
                            Console.WriteLine("[INFO] Current RS: " + modelExpr);
                            printRS = false;
                        }
                        List<Expr> generalizeExprs = generalizeRSExpression(bound, modelExpr, controlVarExpr, args, record, constantBound.Name);
                        record = false;
                        if (generalizeExprs.Count == 0)
                            return null;
                        houdiniExprs.AddRange(generalizeExprs);
                        // andExpr = Expr.And(andExpr, generalizeExpr);
                        // generalized = true;
                    }
                    else if (firstBound)
                    {
                        term = (function2Value[tup.Item1].Gamma(varList));
                        term = Expr.Eq(controlVarExpr, term);
                        if (controlVar.InParams.Count != 0)
                        {
                            term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                                new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                                term);
                        }
                        terms.Add(term);
                    }
                    
                }
                firstBound = false;
                if (houdiniExprs.Count > 0)
                {
                    Expr andExpr = BinaryTreeAnd(houdiniExprs, 0, houdiniExprs.Count - 1);
                    // RSConstant2GeneralizeExpr.Add(constantBound.Name, andExpr);
                    Expr impExpr = Expr.Imp(callExpr, andExpr);
                    terms.Add(impExpr);
                    // conjuncts.Add(impLEExpr);
                }
            }
            // tmpConstants = boolConstants.Select(x => x.Name);
            // constants.AddRange(tmpConstants);
            
            
            /*// old version below
            int index = 0;
            foreach (var tup in impl2FuncCalls[impl])
            {
                var controlVar = tup.Item2;
                var exprVars = tup.Item3;
                var varList = new List<Expr>();
                exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));

                var args = new List<Expr>();
                controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                
                Expr controlVarExpr = new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args);
                terms.Add(controlVarExpr);

                Expr term;
                if (functionForRecurrentSet.Contains(tup.Item1))
                {
                    // generalize R(X)
                    IEnumerable<string> boolConstants;
                    Expr modelExpr = (function2Value[tup.Item1].Gamma(varList));
                    Expr generalizeExpr = generalizeRSExpression(index, modelExpr, controlVarExpr, args, out boolConstants);
                    if (generalizeExpr == null)
                        return;
                    constants.AddRange(boolConstants);
                    term = generalizeExpr;
                }
                else
                {
                    term = (function2Value[tup.Item1].Gamma(varList));
                    term = Expr.Eq(controlVarExpr, term);
                }
                
                // Expr term = Expr.Eq(controlVarExpr, value);

                if (controlVar.InParams.Count != 0)
                {
                    term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                        new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                        term);
                }
                terms.Add(term);
                index += 1;
            }*/
            
            var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
            env.Typecheck(new TypecheckingContext((IErrorSink)null));
            var envVC = prover.Context.BoogieExprTranslator.Translate(env);
            var vc = gen.Implies(envVC, impl2VC[impl]);

            #endregion
            
            var handler = impl2ErrorHandler[impl].Item1;
            var collector = new GeneralizeCheckCallBack(this, impl);
            (handler as VCGen.ErrorReporter).callback = collector; 
                
            VCisValid = true;

            prover.Push();
            prover.MinimizeUnsatCore();
            prover.Assert(gen.Not(vc), true);
            prover.FlushAxiomsToTheoremProver();
            
            // test
            /*prover.Check();
            ProverInterface.Outcome proverOutcome0 = prover.CheckOutcomeCore(handler);*/
            
            List<string> unsatCore = null;
            try
            {
                unsatCore = prover.CheckAndUnsatCore(constants);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                // generalization_enabled = false;
            }

            if (unsatCore != null)
            {
                Console.WriteLine("[Debug] RS unsat core: " + unsatCore.Concat(" "));
                if (unsatCore.Count != 1)
                {
                    Console.WriteLine("[ERROR] seems get more than one RS unsat core!");
                    return null;
                }
                String RSConstant = unsatCore.First();
                Expr generalizeExpr = RSConstant2GeneralizeExpr[RSConstant];
                Console.WriteLine("[INFO] Generalized RS: " + generalizeExpr);
                /*
                constantsGeneralized.Add(Tuple.Create(unsatCore, pos));*/
                prover.Pop();
                return generalizeExpr;
            }
            else
            {
                Console.WriteLine("[INFO] RS Generalization failed.");
                prover.Pop();
                return null;
            }

            /*prover.Check();
            ProverInterface.Outcome proverOutcome = prover.CheckOutcomeCore(handler);
            // check the vc is unsatisfiable
            
            if (!VCisValid)
            {
                throw new Exception("debug: the generalization vc is invalid!");
            }*/
                
            // TODO : now the vc is unsat
            // then generalize by obtaining unsat core
            prover.Pop();
        }

        
        private List<Expr> generalizeRSExpression(int bound, Expr modelExpr, Expr controlVarExpr, List<Expr> args,
            bool record, string constantName)
        {
            List<Expr> res = new List<Expr>();
            // process modelExpr
            NAryExpr expr = modelExpr as NAryExpr;
            if (expr == null)
            {
                // constants = new List<string>();
                return res;
            }
            BinaryOperator op = expr.Fun as BinaryOperator;
            String opName = op.FunctionName;
            List<Expr> exprArgs = expr.Args;
            
            // List<Expr> conjuncts = new List<Expr>();
            // HashSet<Function> boolConstants = new HashSet<Function>();
            if (opName.Equals("<=") || opName.Equals("<"))
            {
                if (exprArgs[0] is LiteralExpr)
                {
                    LiteralExpr lhsExpr = exprArgs[0] as LiteralExpr;
                    Expr rhsExpr = exprArgs[1];
                    int lhs = lhsExpr.asBigNum.ToIntSafe;
                    // generalize c <(=) f(x) to c - d <(=) f(x)
                    // foreach (var bound in boundForRSGeneralization)
                    // {
                        // var constantLE = new Function(Token.NoToken, "GeneralizeRSConstantLE" + "_" + index + "_" + bound, new List<Variable>(),
                        //     new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                
                        // boolConstants.Add(constantLE);

                        // Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantLE), new List<Expr>());
                        Expr leExpr;
                        if (opName.Equals("<="))
                        {
                            leExpr = Expr.Le(Expr.Literal(lhs - bound), rhsExpr);
                        }
                        else
                        {
                            leExpr = Expr.Lt(Expr.Literal(lhs - bound), rhsExpr);
                        }
                        // RSConstant2GeneralizeExpr.Add(constantLE.Name, leExpr);
                        if (record)
                        {
                            RSConstant2GeneralizeExpr.Add(constantName, leExpr);
                        }

                        Expr impLEExpr0 = Expr.Imp(controlVarExpr, leExpr);
                        // Expr impLEExpr = Expr.Imp(callLEExpr, impLEExpr0);
                        // conjuncts.Add(impLEExpr);
                        res.Add(impLEExpr0);
                        Expr impLEExpr1 = Expr.Imp(leExpr, controlVarExpr);
                        res.Add(impLEExpr1);
                    // }
                    // constants = boolConstants.Select(x => x.Name);
                    // return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
                }
                else if (exprArgs[1] is LiteralExpr)
                {
                    LiteralExpr rhsExpr = exprArgs[1] as LiteralExpr;
                    Expr lhsExpr = exprArgs[0];
                    int rhs = rhsExpr.asBigNum.ToIntSafe;
                    // generalize f(x) <(=) c to f(x) <= c + d
                    // foreach (var bound in boundForRSGeneralization)
                    // {
                        // var constantLE = new Function(Token.NoToken, "GeneralizeRSConstantLE" + "_" + index + "_" + bound, new List<Variable>(),
                        //     new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                        //
                        // boolConstants.Add(constantLE);

                        // Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantLE), new List<Expr>());
                        Expr leExpr;
                        if (opName.Equals("<="))
                        {
                            leExpr = Expr.Le(lhsExpr, Expr.Literal(rhs + bound));
                        }
                        else
                        {
                            leExpr = Expr.Lt(lhsExpr, Expr.Literal(rhs + bound));
                        }
                        // RSConstant2GeneralizeExpr.Add(constantLE.Name, leExpr);
                        if (record)
                        {
                            RSConstant2GeneralizeExpr.Add(constantName, leExpr);
                        }

                        Expr impLEExpr0 = Expr.Imp(controlVarExpr, leExpr);
                        // Expr impLEExpr = Expr.Imp(callLEExpr, impLEExpr0);
                        // conjuncts.Add(impLEExpr);
                        res.Add(impLEExpr0);
                        Expr impLEExpr1 = Expr.Imp(leExpr, controlVarExpr);
                        res.Add(impLEExpr1);
                    // }
                    // constants = boolConstants.Select(x => x.Name);
                    // return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
                    return res;
                }
                /*IdentifierExpr lhsExpr = exprArgs[0] as IdentifierExpr;
                LiteralExpr rhsExpr = exprArgs[1] as LiteralExpr;
                int rhs = rhsExpr.asBigNum.ToIntSafe;
                // generalize x <(=) c to x <= c + d
                    // TODO: distinguish <= and <?
                foreach (var bound in boundForRSGeneralization)
                {
                    var constantLE = new Function(Token.NoToken, "GeneralizeRSConstantLE" + "_" + index + "_" + bound, new List<Variable>(),
                        new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                
                    boolConstants.Add(constantLE);

                    Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantLE), new List<Expr>());
                    Expr leExpr = Expr.Le(lhsExpr, Expr.Literal(rhs + bound));
                    RSConstant2GeneralizeExpr.Add(constantLE.Name, leExpr);
                    // constant2GeneralizeExpr.Add(constantLE.Name, Tuple.Create<int, int, int>(i, 1, bound));

                    Expr impLEExpr0 = Expr.Imp(controlVarExpr, leExpr);
                    Expr impLEExpr = Expr.Imp(callLEExpr, impLEExpr0);
                    conjuncts.Add(impLEExpr);
                }
                /*Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args),
                    Expr.True);
                conjuncts.Add(term);#1#

                constants = boolConstants.Select(x => x.Name);
                return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);*/

            }
            else if (opName.Equals(">=") || opName.Equals(">"))
            {
                if (exprArgs[0] is LiteralExpr)
                {
                    LiteralExpr lhsExpr = exprArgs[0] as LiteralExpr;
                    Expr rhsExpr = exprArgs[1];
                    int lhs = lhsExpr.asBigNum.ToIntSafe;
                    // generalize c >(=) f(x) to c + d >= f(x)
                    // foreach (var bound in boundForRSGeneralization)
                    // {
                        // var constantGE = new Function(Token.NoToken, "GeneralizeRSConstantGE" + "_" + index + "_" + bound, new List<Variable>(),
                        //     new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                        //
                        // boolConstants.Add(constantGE);

                        // Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantGE), new List<Expr>());
                        Expr geExpr;
                        if (opName.Equals(">="))
                        {
                            geExpr = Expr.Ge(Expr.Literal(lhs + bound), rhsExpr);
                        }
                        else
                        {
                            geExpr = Expr.Gt(Expr.Literal(lhs + bound), rhsExpr);
                        }
                        // RSConstant2GeneralizeExpr.Add(constantGE.Name, geExpr);
                        if (record)
                        {
                            RSConstant2GeneralizeExpr.Add(constantName, geExpr);
                        }

                        Expr impGEExpr0 = Expr.Imp(controlVarExpr, geExpr);
                        // Expr impGEExpr = Expr.Imp(callLEExpr, impGEExpr0);
                        // conjuncts.Add(impGEExpr);
                        Expr impGEExpr1 = Expr.Imp(geExpr, controlVarExpr);
                        res.Add(impGEExpr0);
                        res.Add(impGEExpr1);
                    // }
                    // constants = boolConstants.Select(x => x.Name);
                    // return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
                    return res;
                }
                else if (exprArgs[1] is LiteralExpr)
                {
                    LiteralExpr rhsExpr = exprArgs[1] as LiteralExpr;
                    Expr lhsExpr = exprArgs[0];
                    int rhs = rhsExpr.asBigNum.ToIntSafe;
                    // generalize f(x) >(=) c to f(x) >= c - d
                    // foreach (var bound in boundForRSGeneralization)
                    // {
                        // var constantGE = new Function(Token.NoToken, "GeneralizeRSConstantGE" + "_" + index + "_" + bound, new List<Variable>(),
                        //     new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                        //
                        // boolConstants.Add(constantGE);
                        //
                        // Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantGE), new List<Expr>());
                        Expr geExpr;
                        if (opName.Equals(">="))
                        {
                            geExpr = Expr.Ge(lhsExpr, Expr.Literal(rhs - bound));
                        }
                        else
                        {
                            geExpr = Expr.Gt(lhsExpr, Expr.Literal(rhs - bound));
                        }
                        // RSConstant2GeneralizeExpr.Add(constantGE.Name, geExpr);
                        if (record)
                        {
                            RSConstant2GeneralizeExpr.Add(constantName, geExpr);
                        }

                        Expr impGEExpr0 = Expr.Imp(controlVarExpr, geExpr);
                        // Expr impGEExpr = Expr.Imp(callLEExpr, impGEExpr0);
                        // conjuncts.Add(impGEExpr);
                        res.Add(impGEExpr0);
                        Expr impGEExpr1 = Expr.Imp(geExpr, controlVarExpr);
                        res.Add(impGEExpr1);
                    // }
                    // constants = boolConstants.Select(x => x.Name);
                    // return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
                    return res;
                }
            }

            // handle && or ||: generalize the first expr
            List<String> opNames = new List<string>();
            List<Expr> opArgs = new List<Expr>();
            NAryExpr curExpr = expr;
            while (opName.Equals("||") || opName.Equals("&&"))
            {
                opNames.Add(opName);
                List<Expr> curExprArgs = curExpr.Args;
                opArgs.Add(curExprArgs[1]);
                curExpr = curExprArgs[0] as NAryExpr;
                if (curExpr == null)
                {
                    break;
                }
                opName = curExpr.Fun.FunctionName;
                if (opName.Equals("<=") || opName.Equals("<"))
                {
                    List<Expr> curArgs = curExpr.Args;
                    if (curArgs[0] is LiteralExpr)
                    {
                        LiteralExpr lhsExpr = curArgs[0] as LiteralExpr;
                        Expr rhsExpr = curArgs[1];
                        int lhs = lhsExpr.asBigNum.ToIntSafe;
                        // generalize c <(=) f(x) to c - d <(=) f(x)
                        // foreach (var bound in boundForRSGeneralization)
                        // {
                            // var constantLE = new Function(Token.NoToken, "GeneralizeRSConstantLE" + "_" + index + "_" + bound, new List<Variable>(),
                            //     new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                            //
                            // boolConstants.Add(constantLE);

                            // Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantLE), new List<Expr>());
                            Expr leExpr;
                            if (opName.Equals("<="))
                            {
                                leExpr = Expr.Le(Expr.Literal(lhs - bound), rhsExpr);
                            }
                            else
                            {
                                leExpr = Expr.Lt(Expr.Literal(lhs - bound), rhsExpr);
                            }
                            // add other exprs of the modelExpr
                            for (int i = opNames.Count-1; i >= 0; i--)
                            {
                                String curOP = opNames[i];
                                Expr curRhs = opArgs[i];
                                if (curOP.Equals("&&"))
                                {
                                    leExpr = Expr.And(leExpr, curRhs);
                                }
                                else if (curOP.Equals("||"))
                                {
                                    leExpr = Expr.Or(leExpr, curRhs);
                                }
                            }
                            // RSConstant2GeneralizeExpr.Add(constantLE.Name, leExpr);
                            if (record)
                            {
                                RSConstant2GeneralizeExpr.Add(constantName, leExpr);
                            }

                            Expr impLEExpr0 = Expr.Imp(controlVarExpr, leExpr);
                            // Expr impLEExpr = Expr.Imp(callLEExpr, impLEExpr0);
                            // conjuncts.Add(impLEExpr);
                            res.Add(impLEExpr0);
                            Expr impLEExpr1 = Expr.Imp(leExpr, controlVarExpr);
                            res.Add(impLEExpr1);
                        // }
                        // constants = boolConstants.Select(x => x.Name);
                        // return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
                        return res;
                    }
                    else if (curArgs[1] is LiteralExpr)
                    {
                        LiteralExpr rhsExpr = curArgs[1] as LiteralExpr;
                        Expr lhsExpr = curArgs[0];
                        int rhs = rhsExpr.asBigNum.ToIntSafe;
                        // generalize f(x) <(=) c to f(x) <= c + d
                        // foreach (var bound in boundForRSGeneralization)
                        // {
                            // var constantLE = new Function(Token.NoToken, "GeneralizeRSConstantLE" + "_" + index + "_" + bound, new List<Variable>(),
                            //     new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                            //
                            // boolConstants.Add(constantLE);

                            // Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantLE), new List<Expr>());
                            Expr leExpr;
                            if (opName.Equals("<="))
                            {
                                leExpr = Expr.Le(lhsExpr, Expr.Literal(rhs + bound));
                            }
                            else
                            {
                                leExpr = Expr.Lt(lhsExpr, Expr.Literal(rhs + bound));
                            }
                            // add other exprs of the modelExpr
                            for (int i = opNames.Count-1; i >= 0; i--)
                            {
                                String curOP = opNames[i];
                                Expr curRhs = opArgs[i];
                                if (curOP.Equals("&&"))
                                {
                                    leExpr = Expr.And(leExpr, curRhs);
                                }
                                else if (curOP.Equals("||"))
                                {
                                    leExpr = Expr.Or(leExpr, curRhs);
                                }
                            }
                            
                            // RSConstant2GeneralizeExpr.Add(constantLE.Name, leExpr);
                            if (record)
                            {
                                RSConstant2GeneralizeExpr.Add(constantName, leExpr);
                            }

                            Expr impLEExpr0 = Expr.Imp(controlVarExpr, leExpr);
                            // Expr impLEExpr = Expr.Imp(callLEExpr, impLEExpr0);
                            // conjuncts.Add(impLEExpr);
                            res.Add(impLEExpr0);
                            Expr impLEExpr1 = Expr.Imp(leExpr, controlVarExpr);
                            res.Add(impLEExpr1);
                        // }
                        // constants = boolConstants.Select(x => x.Name);
                        // return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
                        return res;
                    }
                }
                else if (opName.Equals(">=") || opName.Equals(">"))
                {
                    List<Expr> curArgs = curExpr.Args;
                    if (curArgs[0] is LiteralExpr)
                    {
                        LiteralExpr lhsExpr = curArgs[0] as LiteralExpr;
                        Expr rhsExpr = curArgs[1];
                        int lhs = lhsExpr.asBigNum.ToIntSafe;
                        // generalize c >(=) f(x) to c + d >= f(x)
                        // foreach (var bound in boundForRSGeneralization)
                        // {
                            // var constantGE = new Function(Token.NoToken, "GeneralizeRSConstantGE" + "_" + index + "_" + bound, new List<Variable>(),
                            //     new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                            //
                            // boolConstants.Add(constantGE);
                            //
                            // Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantGE), new List<Expr>());
                            Expr geExpr;
                            if (opName.Equals(">="))
                            {
                                geExpr = Expr.Ge(Expr.Literal(lhs + bound), rhsExpr);
                            }
                            else
                            {
                                geExpr = Expr.Gt(Expr.Literal(lhs + bound), rhsExpr);
                            }
                            // add other exprs of the modelExpr
                            for (int i = opNames.Count-1; i >= 0; i--)
                            {
                                String curOP = opNames[i];
                                Expr curRhs = opArgs[i];
                                if (curOP.Equals("&&"))
                                {
                                    geExpr = Expr.And(geExpr, curRhs);
                                }
                                else if (curOP.Equals("||"))
                                {
                                    geExpr = Expr.Or(geExpr, curRhs);
                                }
                            }
                            // RSConstant2GeneralizeExpr.Add(constantGE.Name, geExpr);
                            if (record)
                            {
                                RSConstant2GeneralizeExpr.Add(constantName, geExpr);
                            }

                            Expr impGEExpr0 = Expr.Imp(controlVarExpr, geExpr);
                            // Expr impGEExpr = Expr.Imp(callLEExpr, impGEExpr0);
                            // conjuncts.Add(impGEExpr);
                            res.Add(impGEExpr0);
                            Expr impGEExpr1 = Expr.Imp(geExpr, controlVarExpr);
                            res.Add(impGEExpr1);
                        // }
                        // constants = boolConstants.Select(x => x.Name);
                        // return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
                        return res;
                    }
                    else if (curArgs[1] is LiteralExpr)
                    {
                        LiteralExpr rhsExpr = curArgs[1] as LiteralExpr;
                        Expr lhsExpr = curArgs[0];
                        int rhs = rhsExpr.asBigNum.ToIntSafe;
                        // generalize f(x) >(=) c to f(x) >= c - d
                        // foreach (var bound in boundForRSGeneralization)
                        // {
                            // var constantGE = new Function(Token.NoToken, "GeneralizeRSConstantGE" + "_" + index + "_" + bound, new List<Variable>(),
                            //     new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                            //
                            // boolConstants.Add(constantGE);
                            //
                            // Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantGE), new List<Expr>());
                            Expr geExpr;
                            if (opName.Equals(">="))
                            {
                                geExpr = Expr.Ge(lhsExpr, Expr.Literal(rhs - bound));
                            }
                            else
                            {
                                geExpr = Expr.Gt(lhsExpr, Expr.Literal(rhs - bound));
                            }
                            // add other exprs of the modelExpr
                            for (int i = opNames.Count-1; i >= 0; i--)
                            {
                                String curOP = opNames[i];
                                Expr curRhs = opArgs[i];
                                if (curOP.Equals("&&"))
                                {
                                    geExpr = Expr.And(geExpr, curRhs);
                                }
                                else if (curOP.Equals("||"))
                                {
                                    geExpr = Expr.Or(geExpr, curRhs);
                                }
                            }
                            // RSConstant2GeneralizeExpr.Add(constantGE.Name, geExpr);
                            if (record)
                            {
                                RSConstant2GeneralizeExpr.Add(constantName, geExpr);
                            }

                            Expr impGEExpr0 = Expr.Imp(controlVarExpr, geExpr);
                            // Expr impGEExpr = Expr.Imp(callLEExpr, impGEExpr0);
                            // conjuncts.Add(impGEExpr);
                            res.Add(impGEExpr0);
                            Expr impGEExpr1 = Expr.Imp(geExpr, controlVarExpr);
                            res.Add(impGEExpr1);
                        // }
                        // constants = boolConstants.Select(x => x.Name);
                        // return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
                        return res;
                    }
                }
                else
                {
                    continue;
                }
            }
            // constants = new List<string>();
            return res;
        }
        
        
        public class Interval
        {
            public int leftbound;
            public int rightbound;

            public Interval(int l=-1000000, int r=1000000)
            {
                leftbound = l;
                rightbound = r;
            }

            public void setBound(int l, int r)
            {
                leftbound = l;
                rightbound = r;
            }
        }
        
        
        private void learnCondition(Expr generalizedRS)
        {
            string tmpDir = Path.GetDirectoryName(filename);
            string tmpFilename = Path.GetFileNameWithoutExtension(filename);
            string taskname = tmpFilename.Substring(0, tmpFilename.Length - 4);
            string IDTFilename = tmpDir + "/IDT_" + taskname;
            // generate IDT files
            // .names--the same as current .names
            string sourceNamesFile = filename + ".names";
            File.Copy(sourceNamesFile, IDTFilename + ".names", true);
            // .dup.data
            string dupDataFile = "";
            string dupDataFilePath = IDTFilename + ".dup.data";
            string impsFile = "";
            string impFilePath = IDTFilename + ".implications";
            int sampleCount = 0;
            // reuse existed dup data and implications
            if (File.Exists(dupDataFilePath))
            {
                var existedData = File.ReadAllLines(dupDataFilePath);
                existedData = existedData.Take(existedData.Length - 1).ToArray();
                foreach (var data in existedData)
                {
                    dupDataFile = dupDataFile + data + "\n";
                }

                sampleCount += existedData.Length;
                var existedImps = File.ReadAllLines(impFilePath);
                existedImps = existedImps.Take(existedImps.Length - 1).ToArray();
                foreach (var impData in existedImps)
                {
                    impsFile = impsFile + impData + "\n";
                }
                
            }
            // translate rs to interval example(false)
            String impl = this.implWithRS.Name;
            String suffix0 = "_instrumented";
            Contract.Assert(impl.EndsWith(suffix0));
            impl = impl.Substring(0, impl.Length - suffix0.Length);
            var tup = impl2FuncCalls[impl][0];
            var exprVars = tup.Item3;
            var varList = new List<Expr>();
            exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));
            Expr RS = generalizedRS;
            if (RS == null)
            {
                RS = function2Value["b1"].Gamma(varList);
            }
            List<Dictionary<string, Interval>> var2Intervals = transferRS2Interval(RS);
            sampleCount += var2Intervals.Count;
            if (var2Intervals.Count == 0)  // positive samples only
            {
                Console.WriteLine("[DEBUG] Unable to transfer rs to interval examples.");
                return;  // if needed?
            }
            dupDataFile += outputIntervalDataWithLabel(var2Intervals);
            // add mdata(true)
            if (mDataList.Count == 0) // negative samples only
            {
                Console.WriteLine("[DEBUG] Unable to get positive mdatas.");
                return;  // if needed?
            }
            foreach (var dp in mDataList)
            {
                dupDataFile += outputDataPoint(dp);
                dupDataFile += ",true\n";
            }

            sampleCount += mDataList.Count;
            
            // .implications--reuse the current rsl implication and flip the true/false
            string implicationFile = filename + ".implications";
            // string[] rslImplicationFiles = Directory.GetFiles(tmpDir, "*_rsl.bpl.implications");
            // foreach (var implicationFile in rslImplicationFiles)
            // {
                string suffix = ".implications";
                string dataFile = implicationFile.Substring(0, implicationFile.Length - suffix.Length) + ".data";
                var dataContent = File.ReadAllLines(dataFile);
                var implicationContent = File.ReadAllLines(implicationFile);
                foreach (var implication in implicationContent)
                {
                    var indices = implication.Split(' ');
                    if (indices.Length == 2)
                    {
                        int imp1, imp2;
                        bool success1 = int.TryParse(indices[0], out imp1);
                        bool success2 = int.TryParse(indices[1], out imp2);
                        if (success1 && success2)
                        {
                            string data1 = dataContent[imp1];
                            string data2 = dataContent[imp2];
                            // flip data
                            if (data1.EndsWith("true"))
                                data1 = data1.Substring(0, data1.Length - 4) + "false";
                            else if (data1.EndsWith("false"))
                                data1 = data1.Substring(0, data1.Length - 5) + "true";
                            if (data2.EndsWith("true"))
                                data2 = data2.Substring(0, data2.Length - 4) + "false";
                            else if (data2.EndsWith("false"))
                                data2 = data2.Substring(0, data2.Length - 5) + "true";
                            
                            // add data
                            dupDataFile = dupDataFile + data1 + "\n" + data2 + "\n";
                            impsFile = impsFile + sampleCount + " " + (sampleCount + 1) + "\n";
                            sampleCount += 2;
                        }
                    }
                }
            // }

            using (System.IO.StreamWriter sw = System.IO.File.CreateText(IDTFilename + ".dup.data"))
            {
                sw.WriteLine(dupDataFile);
            }
            using (System.IO.StreamWriter sw = System.IO.File.CreateText(IDTFilename + ".implications"))
            {
                sw.WriteLine(impsFile);
            }
            
            // invoke the IDT learner
            var start = DateTime.Now;
            ProcessStartInfo process = new ProcessStartInfo();
            process.FileName = "./IDT4Inv";
            process.Arguments = "-o " + IDTFilename + ".tree.json " + IDTFilename;
            if (CommandLineOptions.Clo.Trace)
            {
                Console.WriteLine("IDT filename: " + process.FileName);
            }
            process.WindowStyle = ProcessWindowStyle.Hidden;
            process.CreateNoWindow = true;
            process.UseShellExecute = false;
            process.RedirectStandardOutput = true;

            Process proc = Process.Start(process);
            string output = proc.StandardOutput.ReadToEnd();
            proc.WaitForExit();
            var inc = DateTime.Now - start;
            // c5LearnerTime += inc;
            // c5LearnerQueries++;

            // Retrieve the app's exit code
            int exitCode = proc.ExitCode;
            if (exitCode < 0)
            {
                Console.WriteLine("[ERROR] The learner seems to have run into an error!");
                return;
            } 
            if (CommandLineOptions.Clo.Trace)
                Console.WriteLine("Learner (IDT) Time taken = " + inc.TotalSeconds.ToString());

            // process the result
            start = DateTime.Now;
            string treeFile = IDTFilename + ".tree.json";
            if (!File.Exists(treeFile))
            {
                Console.WriteLine("[ERROR] The learner fail to learn a condition!");
                return;
            }
            string c5JSONTree = File.ReadAllText(treeFile);     
            C5TreeNode root = JsonConvert.DeserializeObject<C5TreeNode>(c5JSONTree);
            function2Value["b1"].constructModel("b1", root, attribute2Expr, functionID);
            this.jsontime += (DateTime.Now - start);
            
            Console.WriteLine("[INFO] Learned Condition: " + function2Value["b1"].Gamma(varList).ToString());
        }
        
        
        private bool haveNondetInLoop(List<Block> trace)
        {
            bool ret = false;
            bool header = false;
            foreach (var b in trace)
            {
                if (!header && b.rsHeader)
                {
                    header = true;
                }

                if (header)
                {
                    if (b.haveNondetAssign) {
                        ret = true;
                        break;
                    }
                }
            }

            return ret;
        }

        private Expr computeWlpForErrorTrace(List<Block> trace, Expr starting, AssertCmd failing, out NondetApproxAssumeCmd nondetCmd)
        {
            int len = trace.Count;
            Block last = trace[len - 1];

            int i = last.Cmds.IndexOf(failing); // should not fail.
            
            Expr current = starting;

            int counter = len - 1;
            Block b = last;

            while (counter >= 0)
            {
                bool shouldcontinue = computeWlpForBlock(b, i, ref current, out nondetCmd);
                if (!shouldcontinue)
                {
                    return current;
                }
                counter--;
                b = trace[counter];
                i = b.Cmds.Count;
            }

            nondetCmd = null;
            return current;
        }

        // compute wlp of current from position i
        // stop at a havoc cmd and return it
        // else return null
        private bool computeWlpForBlock(Block block, int i, ref Expr current, out NondetApproxAssumeCmd nondetCmd)
        {
            Contract.Assert(i <= block.Cmds.Count);
            int c = i - 1;

            while (c >= 0)
            {
                Cmd cmd = block.Cmds[c];
                Contract.Assert(cmd is AssertCmd || cmd is AssumeCmd);
                // compute wlp(cmd, current) -> current
                if (cmd is NondetApproxAssumeCmd)
                {
                    var fcollector = new FunctionCollector();
                    fcollector.Visit(cmd);
                    Function func = fcollector.functionsUsed[0].Item1;
                                        
                    HavocCmd originalHavoc = havocInstruments[func.Name];
                    Contract.Assert(originalHavoc != null);
                    // TODO: check if the computed wlp is sound to be used
                    // as underapproximation
                    // if not, return null
                    var validator = new HavocUnderApproxValidator(originalHavoc.Vars);
                    if (validator.visit(current))
                    {
                        // it is sound to insert underapproximation here
                        Console.WriteLine("underapproximation valid");
                        nondetCmd = (NondetApproxAssumeCmd) cmd;
                    }
                    else
                    {
                        Console.WriteLine("underapproximation invalid, disabled for this round");
                        nondetCmd = null;
                    }
                    return false;
                }
                else if (cmd is AssertCmd)
                {
                    // TODO maybe ignore?
                    current = Expr.And(current, ((AssertCmd) cmd).Expr);
                }
                else
                {
                    AssumeCmd assumeCmd = cmd as AssumeCmd;
                    if (QKeyValue.FindBoolAttribute(assumeCmd.Attributes, "partition"))
                    {
                        current = Expr.And(current, assumeCmd.Expr);
                    }
                    else
                    {
                        // assignment
                        NAryExpr assignment = assumeCmd.Expr as NAryExpr;
                        Contract.Assert(assignment != null);
                        BinaryOperator bop = assignment.Fun as BinaryOperator;
                        Contract.Assert(bop != null && bop.Op == BinaryOperator.Opcode.Eq
                                                    && assignment.Args[0] is IdentifierExpr);

                        IdentifierExpr id = assignment.Args[0] as IdentifierExpr;
                        current = ExtendsExpr.replace(current, new List<string>() {id.Name},
                            new List<Expr>() {assignment.Args[1]});
                    }
                }
                c--;
            }

            nondetCmd = null;
            return true;
        }

        private void flipAndGeneralizePositiveSample()
        {
            dataPoint pos = null;
            foreach (var pair in c5samplePointToClassAttr)
            {
                var point = pair.Key;
                var attr = pair.Value;
                if (attr == 1)
                {
                    pos = point;
                    break;
                }
            }
            
            Contract.Assert(pos != null);

            c5samplePointToClassAttr[pos] = 0;
            if (CommandLineOptions.Clo.Trace)
            {
                Console.WriteLine("flip false positive to negative (?): " + pos.print());
            }
            
            // Generalize
            if (generalization_enabled)
                generalizePositive(pos);

            // reset havoc (old, useless code?)
            HavocApproximated = false;
            List<string> keys = extraFunc2Value.Keys.ToList();
            foreach (var p in keys)
            {
                extraFunc2Value[p] = Expr.True;
            }
        }

        private int generalize_cnt = 0;

        private bool generalization_enabled = true;
        
        private void generalizePositive(dataPoint pos)
        {
            int iterationCount = getIterationCnt(pos);
            if (!helperImpls.ContainsKey(iterationCount)) return;
            
            Implementation helper = helperImpls[iterationCount];
            Console.WriteLine("Generalizing positive sample blocked set with iteration " + iterationCount);
            string impl = helper.Name;

            List<string> constants = new List<string>();
            
            #region vcgen

            var gen = prover.VCExprGen;
            var terms = new List<Expr>();
            
            Contract.Assert(impl2FuncCalls[impl].Count == 1);
            var tup = impl2FuncCalls[impl][0];
            {
                var controlVar = tup.Item2;
                var exprVars = tup.Item3;
                var varList = new List<Expr>();
                exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));

                var args = new List<Expr>();
                controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                
                Expr term;
                if (functionForRecurrentSet.Contains(tup.Item1))
                {
                    // TODO: replace b0(x, y, z, ...) to x = x0 /\ y = y0 ...
                    // where (x0, y0, ...) is the datapoint pos
                    IEnumerable<string> boolConstants;
                    Expr generalizeExpr = generalizeExpression(varList, pos, controlVar, args, out boolConstants);
                    constants.AddRange(boolConstants);
                    term = generalizeExpr;
                }
                else
                {
                    term = (function2Value[tup.Item1].Gamma(varList));
                    term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args),
                                 term);
                }

                if (controlVar.InParams.Count != 0)
                {
                    term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                        new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                        term);
                }
                terms.Add(term);
            }
            
            var env = BinaryTreeAnd(terms, 0, terms.Count - 1);

            env.Typecheck(new TypecheckingContext((IErrorSink)null));
            var envVC = prover.Context.BoogieExprTranslator.Translate(env);
            var vc = gen.Implies(envVC, impl2VC[impl]);
            
            #endregion
            
                var handler = impl2ErrorHandler[impl].Item1;
                var collector = new GeneralizeCheckCallBack(this, impl);
            
                (handler as VCGen.ErrorReporter).callback = collector; 
                
                VCisValid = true;

                prover.Push();
                prover.Assert(gen.Not(vc), true);
                
                // note: we want to prove that the vc is in fact unsat
                // so no negation here? -- nope
                // prover.Assert(vc, true);
                
                prover.FlushAxiomsToTheoremProver();
                List<string> unsatCore = null;
                try
                {
                    unsatCore = prover.CheckAndUnsatCore(constants);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                    generalization_enabled = false;
                }

                if (unsatCore != null)
                {
                    Console.WriteLine("debug: unsat core: " + unsatCore.Concat(" "));
                    if (unsatCore.Count != pos.value.Count)
                    {
                        Console.WriteLine("debug: effective unsat core computation");
                    }
                    constantsGeneralized.Add(Tuple.Create(unsatCore, pos));
                }

                // ProverInterface.Outcome proverOutcome = prover.CheckOutcomeCore(handler);
                // check the vc is unsatisfiable
            
                // if (!VCisValid)
                // {
                //     throw new Exception("debug: the generalization vc is invalid!");
                // }
                
                // TODO : now the vc is unsat
                // then generalize by obtaining unsat core
                prover.Pop();
        }

        private int getIterationCnt(dataPoint pos)
        {
            HashSet<dataPoint> visited = new HashSet<dataPoint>();
            Stack<Tuple<dataPoint, int>> worklist = new Stack<Tuple<dataPoint, int>>();
           
            worklist.Push(Tuple.Create(pos, 0));
            while (worklist.Count != 0)
            {
                var tup = worklist.Pop();
                var p = tup.Item1;
                var index = tup.Item2;

                if (c5samplePointToClassAttr[p] == 2)
                {
                    return index;
                }
                
                if (!implicationDictionary.ContainsKey(p)) continue;
                
                HashSet<dataPoint> set = implicationDictionary[p];

                foreach (var newp in set)
                {
                    if (!visited.Contains(newp))
                    {
                        worklist.Push(Tuple.Create<dataPoint, int>(newp, index + 1));
                    }
                }
            }

            return 10000; // just to make sure generalization is ignored
        }

        private Expr generalizeExpression(List<Expr> varList, dataPoint pos, Function controlVar, List<Expr> args,
            out IEnumerable<string> constants)
        {
            List<Expr> conjuncts = new List<Expr>();
            List<int> values = pos.value;
            
            Contract.Assert(values.Count == varList.Count);
            int cnt = values.Count;

            HashSet<Function> boolConstants = new HashSet<Function>();
            // List<Expr> callExprs = new List<Expr>();

            // variable elimination
            // for (int i = 0; i < cnt; ++i)
            // {
            //     var constant = new Function(Token.NoToken, "GeneralizeConstant" + generalize_cnt + "_" + i, new List<Variable>(),
            //         new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
            //     
            //     boolConstants.Add(constant);
            //
            //     Expr callExpr = new NAryExpr(Token.NoToken, new FunctionCall(constant), new List<Expr>());
            //     
            //     Expr eqExpr = Expr.Eq(Expr.Literal(values[i]), varList[i]);
            //     constant2GeneralizeExpr.Add(constant.Name, i);
            //     
            //     Expr impExpr = Expr.Imp(callExpr, eqExpr);
            //     
            //     // callExprs.Add(callExpr);
            //     conjuncts.Add(impExpr);
            // }
            for (int i = 0; i < cnt; ++i)
            {
                foreach (var bound in boundForGeneralization)
                {
                    var constantGE = new Function(Token.NoToken, "GeneralizeConstantGE" + generalize_cnt + "_" + i + "_" + bound, new List<Variable>(),
                        new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                
                    boolConstants.Add(constantGE);

                    Expr callGEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantGE), new List<Expr>());
                    Expr geExpr = Expr.Ge(varList[i], Expr.Literal(values[i] - bound));
                    constant2GeneralizeExpr.Add(constantGE.Name, Tuple.Create(i, 0, bound));
                
                    Expr impGEExpr = Expr.Imp(callGEExpr, geExpr);
                
                    conjuncts.Add(impGEExpr);
                    
                    var constantLE = new Function(Token.NoToken, "GeneralizeConstantLE" + generalize_cnt + "_" + i + "_" + bound, new List<Variable>(),
                        new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                
                    boolConstants.Add(constantLE);

                    Expr callLEExpr = new NAryExpr(Token.NoToken, new FunctionCall(constantLE), new List<Expr>());
                    Expr leExpr = Expr.Le(varList[i], Expr.Literal(values[i] + bound));
                    constant2GeneralizeExpr.Add(constantLE.Name, Tuple.Create<int, int, int>(i, 1, bound));
                
                    Expr impLEExpr = Expr.Imp(callLEExpr, leExpr);
                
                    conjuncts.Add(impLEExpr);
                }
            }

            generalize_cnt++;
            
            // Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args),
                                 // BinaryTreeAnd(callExprs, 0, callExprs.Count - 1));
            Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args),
                                 Expr.True);
            conjuncts.Add(term);

            constants = boolConstants.Select(x => x.Name);
            return BinaryTreeAnd(conjuncts, 0, conjuncts.Count - 1);
        }

        private bool CheckInstrumentedProgram()
        {
            // String impl = this.implWithRS.Name;
            //
            // #region vcgen
            //
            // var gen = prover.VCExprGen;
            // var terms = new List<Expr>();
            // // first check if the header is reachable if we assert '\neg RS'
            // foreach (var tup in impl2FuncCalls[impl])
            // {
            //     var controlVar = tup.Item2;
            //     var exprVars = tup.Item3;
            //     var varList = new List<Expr>();
            //     exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));
            //
            //     var args = new List<Expr>();
            //     controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
            //     Expr value;
            //     if (functionForRecurrentSet.Contains(tup.Item1))
            //     {
            //         value = Expr.Not(function2Value[tup.Item1].Gamma(varList));
            //     }
            //     else
            //     {
            //         value = (function2Value[tup.Item1].Gamma(varList));
            //     }
            //     Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args),
            //                  value);
            //
            //     if (controlVar.InParams.Count != 0)
            //     {
            //         term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
            //             new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
            //             term);
            //     }
            //     terms.Add(term);
            //
            //     /*
            //     foreach (var variable in varList)
            //     {
            //         terms.Add(Expr.Le(variable, Expr.Literal(10)));
            //         terms.Add(Expr.Ge(variable, Expr.Literal(-10)));
            //     }
            //     */
            // }
            // var env = BinaryTreeAnd(terms, 0, terms.Count - 1);
            //
            // env.Typecheck(new TypecheckingContext((IErrorSink)null));
            // var envVC = prover.Context.BoogieExprTranslator.Translate(env);
            // var vc = gen.Implies(envVC, impl2VC[impl]);
            //
            // if (CommandLineOptions.Clo.Trace)
            // {
            //     Console.WriteLine("Verifying {0} For Reachability: ", impl);
            //     //Console.WriteLine("env: {0}", envVC);
            //     var envFuncs = new HashSet<string>();
            //     impl2FuncCalls[impl].Iter(tup => envFuncs.Add(tup.Item1));
            //     envFuncs.Iter(f => PrintFunction(existentialFunctions[f]));
            // }
            //
            // #endregion vcgen
            //
            // var handler = impl2ErrorHandler[impl].Item1;
            // var collector = new InstrumentedCheckCallBack(this, impl);
            //
            // (handler as VCGen.ErrorReporter).callback = collector; 
            //
            // VCisValid = true;   // set to false if there's a counterexample -- which means the original program is proved
            //
            // prover.Push();
            // prover.Assert(gen.Not(vc), true);
            // prover.FlushAxiomsToTheoremProver();
            // prover.Check(); ProverInterface.Outcome proverOutcome = prover.CheckOutcomeCore(handler);
            // prover.Pop();

            // we only need to check if there is a positive example?
            foreach (var pair in c5samplePointToClassAttr)
            {
                if (pair.Value == 1)
                {
                    return false;
                }
            }

            // if (!VCisValid)
            // {
            //     // VC is valid --> original program is proved!
            //     
            //     // return true if needs to continue 
            //     return false;
            // }
            // else
            {
                // the recurrent set learnt is unreachable
                return TryGeneratePositiveSamples();
            }
        }

        // return true if needs to continue 
        private bool TryGeneratePositiveSamples()
        {
            String impl = this.implWithRS.Name;
            // Expr guard = this.implWithRS.LoopGuardExprForRS;

            #region vcgen

            var gen = prover.VCExprGen;
            var terms = new List<Expr>();
            foreach (var tup in impl2FuncCalls[impl])
            {
                var controlVar = tup.Item2;
                var exprVars = tup.Item3;
                var varList = new List<Expr>();
                exprVars.Args.OfType<Expr>().Iter(v => varList.Add(v));

                var args = new List<Expr>();
                controlVar.InParams.Iter(v => args.Add(Expr.Ident(v)));
                Expr value;
                if (functionForRecurrentSet.Contains(tup.Item1))
                {
                    Expr posRequireExpr = generateRequireExpression(varList);
                    // -TD- replace it to the negation of loop guard
                    value = Expr.Not(posRequireExpr);
                }
                else
                {
                    value = (function2Value[tup.Item1].Gamma(varList));
                }
                Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args),
                             value);

                if (controlVar.InParams.Count != 0)
                {
                    term = new ForallExpr(Token.NoToken, new List<Variable>(controlVar.InParams.ToArray()),
                        new Trigger(Token.NoToken, true, new List<Expr> { new NAryExpr(Token.NoToken, new FunctionCall(controlVar), args) }),
                        term);
                }
                terms.Add(term);

                /*
                foreach (var variable in varList)
                {
                    terms.Add(Expr.Le(variable, Expr.Literal(10)));
                    terms.Add(Expr.Ge(variable, Expr.Literal(-10)));
                }
                */
            }
            
            foreach (var p in extraFunc2Value)
            {
                var f = new Function(Token.NoToken, p.Key, new List<Variable>(),
                    new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                
                Expr term = Expr.Eq(new NAryExpr(Token.NoToken, new FunctionCall(f), new List<Expr>()),
                    p.Value);
                terms.Add(term);
            }
            
            var env = BinaryTreeAnd(terms, 0, terms.Count - 1);

            env.Typecheck(new TypecheckingContext((IErrorSink)null));
            var envVC = prover.Context.BoogieExprTranslator.Translate(env);
            var vc = gen.Implies(envVC, impl2VC[impl]);
            
            if (CommandLineOptions.Clo.Trace)
            {
                Console.WriteLine("Verifying {0} For Sample: ", impl);
                //Console.WriteLine("env: {0}", envVC);
                var envFuncs = new HashSet<string>();
                impl2FuncCalls[impl].Iter(tup => envFuncs.Add(tup.Item1));
                envFuncs.Iter(f => PrintFunction(existentialFunctions[f]));
            }

            #endregion vcgen
            
            VCExpr finalVC = null;
            bool hasIntegerVariable = true;

            for (int i = 0; i <= bounds4cex.Count(); i++)
            {
                
                #region boundcexvalues
                // If there are no integer variables, then ensure the loop is only run once.
                if (!hasIntegerVariable)
                    continue;

                /* Last iteration is when there are enforced no bounds on the cex values. */
                if (i < bounds4cex.Count())
                {
                    int bound = bounds4cex.ElementAt(i);
                    terms.Clear();
                    foreach (var tup in impl2FuncCalls[impl])
                    {
                        var exprVars = tup.Item3;
                        var varList = new List<Expr>();
                        exprVars.Args.OfType<Expr>().Where(v => v.Type.IsInt).Iter(v => varList.Add(v));
                        foreach (var variable in varList)
                        {
                            terms.Add(Expr.Le(variable, Expr.Literal(bound)));
                            terms.Add(Expr.Ge(variable, Expr.Literal(-1 * bound)));
                            //terms.Add(Expr.Ge(variable, Expr.Literal(0)));
                        }
                    }

                    if (terms.Count == 0)
                    {
                        // There is no integer argument to the function to learn
                        hasIntegerVariable = false;
                    }

                    var boundcex = BinaryTreeAnd(terms, 0, terms.Count - 1);
                    boundcex.Typecheck(new TypecheckingContext((IErrorSink) null));
                    var boundcexVC = prover.Context.BoogieExprTranslator.Translate(boundcex);

                    finalVC = gen.Implies(boundcexVC, vc);
                }
                else
                {
                    if (!this.useBounds)
                    {
                        finalVC = vc;
                    }
                    else
                    {
                        int bound = 1000000;
                        terms.Clear();
                        foreach (var tup in impl2FuncCalls[impl])
                        {
                            var exprVars = tup.Item3;
                            var varList = new List<Expr>();
                            exprVars.Args.OfType<Expr>().Where(v => v.Type.IsInt).Iter(v => varList.Add(v));
                            foreach (var variable in varList)
                            {
                                terms.Add(Expr.Le(variable, Expr.Literal(bound)));
                                terms.Add(Expr.Ge(variable, Expr.Literal(-1 * bound)));
                                //terms.Add(Expr.Ge(variable, Expr.Literal(0)));
                            }
                        }

                        var boundcex = BinaryTreeAnd(terms, 0, terms.Count - 1);
                        boundcex.Typecheck(new TypecheckingContext((IErrorSink) null));
                        var boundcexVC = prover.Context.BoogieExprTranslator.Translate(boundcex);

                        finalVC = gen.Implies(boundcexVC, vc);
                    }
                }
                
                #endregion boundcexvalues
            
                var handler = impl2ErrorHandler[impl].Item1;
                var collector = new InstrumentedCheckCallBack(this, impl);
            
                (handler as VCGen.ErrorReporter).callback = collector; 
                
                VCisValid = true;

                prover.Push();
                prover.Assert(gen.Not(finalVC), true);
                prover.FlushAxiomsToTheoremProver();
                prover.Check();
                ProverInterface.Outcome proverOutcome = prover.CheckOutcomeCore(handler);
                prover.Pop();

                if (!VCisValid)
                {
                    // the ce is added by callback
                    return true;
                }
                // if it's valid, there's no cex in this bound
                // just fall through
            }
            
            // vc is valid, so the header is unreachable.
            Console.WriteLine("The loop is unreachable : terminating!");
            return false;
        }
        
        private Expr generateRequireExpression(List<Expr> varList)
        {
            var clauses = new List<Expr>();
            Expr guard = ExtendsExpr.replace(this.implWithRS.LoopGuardExprForRS, this.implWithRS.LoopGuardVars,
                varList);
            // clauses.Add(this.implWithRS.LoopGuardExprForRS);

            clauses.Add(guard);
            
            foreach (dataPoint p in terminatingStateSamplesSet)
            {
                // v != p
                var terms = new List<Expr>();
                var values = p.value;
                Contract.Assert(values.Count == varList.Count);
                for (int i = 0; i < values.Count; i++)
                {
                    terms.Add(Expr.Neq(Expr.Literal(values[i]), varList[i]));
                }
            
                // v_0 != p_0 \/ v_1 != p_1 \/ v_2 != p_2 ... 
                var env = BinaryTreeOr(terms, 0, terms.Count - 1);
                clauses.Add(env);
            }

            if (generalization_enabled)
            {
                

            foreach (var tup in constantsGeneralized)
            {
                var constants = tup.Item1;
                var pos = tup.Item2;
                var values = pos.value;
                
                // each constants represent a clause c1, c2, ...
                // together, c1 /\ c2 /\ c3.. should be blocked
                List<Tuple<int, int, int>> blockedVarInfo = constants.Select(x => constant2GeneralizeExpr[x]).ToList();
                List<Expr> terms = new List<Expr>();

                // here c is of the form x <= v + offset or x >= v - offset
                
                // so: not c1 \/ not c2 \/ not c3
                foreach (var info in blockedVarInfo)
                {
                    var index =  info.Item1;
                    var type =  info.Item2;
                    var bound =  info.Item3;
                    if (type == 0)
                    { // GE
                        terms.Add(Expr.Not(Expr.Ge(varList[index], Expr.Literal(values[index] - bound))));
                    }
                    else
                    { // LE
                        terms.Add(Expr.Not(Expr.Le(varList[index], Expr.Literal(values[index] + bound))));
                    }
                }

                // if (blockedVarIndex.Count != 0)
                // {
                //     Console.WriteLine(constants.Concat(" "));
                // }
                var env = BinaryTreeOr(terms, 0, terms.Count - 1);
                clauses.Add(env);
            }
            }

            return BinaryTreeAnd(clauses, 0, clauses.Count - 1);
        }

        public VCGenOutcome ComputeSummaries()
        {
            // Compute SCCs and determine a priority order for impls
            var Succ = new Dictionary<string, HashSet<string>>();
            var Pred = new Dictionary<string, HashSet<string>>();
            name2Impl.Keys.Iter(s => Succ[s] = new HashSet<string>());
            name2Impl.Keys.Iter(s => Pred[s] = new HashSet<string>());

            foreach(var impl in name2Impl.Keys) {
                Succ[impl] = new HashSet<string>();
                impl2functionsAsserted[impl].Iter(f => 
                    function2implAssumed[f].Iter(succ =>
                        {
                            Succ[impl].Add(succ);
                            Pred[succ].Add(impl);
                        }));
            }

            var sccs = new StronglyConnectedComponents<string>(name2Impl.Keys,
                new Adjacency<string>(n => Pred[n]),
                new Adjacency<string>(n => Succ[n]));
            sccs.Compute();
            
            // impl -> priority
            var impl2Priority = new Dictionary<string, int>();
            int p = 0;
            foreach (var scc in sccs)
            {
                foreach (var impl in scc)
                {
                    impl2Priority.Add(impl, p);
                    p++;
                }
            }

            VCGenOutcome overallOutcome = null;

            var start = DateTime.Now;

            overallOutcome = LearnInv(impl2Priority);

            var elapsed = DateTime.Now;
            this.totaltime = elapsed - start;

            if (true)
            {
                Console.WriteLine("Prover time = {0}", proverTime.TotalSeconds.ToString("F2"));
                Console.WriteLine("Number of prover queries = " + numProverQueries);
                Console.WriteLine("C5 Learner time = {0}", c5LearnerTime.TotalSeconds.ToString("F2"));
                //Console.WriteLine("time to parse JSON and construct Boogie Model = {0}", jsontime.TotalSeconds.ToString("F2"));
                Console.WriteLine("Number of C5 Learner queries = " + c5LearnerQueries);

                //Console.WriteLine("Total time: {0}", proverTime.Add(c5LearnerTime).TotalSeconds.ToString("F2"));
                Console.WriteLine("Total time: {0}", totaltime.Subtract(jsontime).TotalSeconds.ToString("F2"));

                Console.WriteLine("Number of examples:" + this.numPosExamples);
                Console.WriteLine("Number of counter-examples:" + this.numNegCounterExamples);
                Console.WriteLine("Number of implications:" + this.numImplications);

                /*Console.WriteLine("Average tree size: " + ((double)this.totalTreeSize / (double)this.c5LearnerQueries));
                Console.WriteLine("Last tree size: " + this.lastTreeSize);
                Console.WriteLine("Average truetrue implications: " + ((double)this.total_truetrue_implications / (double)this.c5LearnerQueries));
                Console.WriteLine("last truetrue implications: " + this.last_truetrue_implications);
                Console.WriteLine("Average falsetrue implications: " + ((double)this.total_falsetrue_implications/ (double)this.c5LearnerQueries));
                Console.WriteLine("last falsetrue implications: " + this.last_falsetrue_implications);
                Console.WriteLine("Average falsefalse implications: " + ((double)this.total_falsefalse_implications / (double)this.c5LearnerQueries));
                Console.WriteLine("last falsefalse implications: " + this.last_falsefalse_implications);                */
            }

            if (CommandLineOptions.Clo.PrintAssignment)
            {
                // Print the existential functions
                existentialFunctions.Values.Iter(PrintFunction);
            }
            
            return overallOutcome;
        }

        private static Expr BinaryTreeAnd(List<Expr> terms, int start, int end)
        {
            if (start > end)
                return Expr.True;
            if (start == end)
                return terms[start];
            if (start + 1 == end)
                return Expr.And(terms[start], terms[start + 1]);
            var mid = (start + end) / 2;
            return Expr.And(BinaryTreeAnd(terms, start, mid), BinaryTreeAnd(terms, mid + 1, end));
        }

        private static Expr BinaryTreeOr(List<Expr> terms, int start, int end)
        {
            if (start > end)
                return Expr.True;
            if (start == end)
                return terms[start];
            if (start + 1 == end)
                return Expr.Or(terms[start], terms[start + 1]);
            var mid = (start + end) / 2;
            return Expr.Or(BinaryTreeOr(terms, start, mid), BinaryTreeOr(terms, mid + 1, end));
        }
        /*
        public IEnumerable<Function> GetAssignment()
        {
            var ret = new List<Function>();
            foreach (var func in existentialFunctions.Values)
            {
                var invars = new List<Expr>(func.InParams.OfType<Variable>().Select(v => Expr.Ident(v)));
                func.Body = function2Value[func.Name].Gamma(invars);
                ret.Add(func);
            }
            return ret;
        }
        */

        private void PrintFunction(Function function)
        {
            var tt = new TokenTextWriter(Console.Out);
            var invars = new List<Expr>(function.InParams.OfType<Variable>().Select(v => Expr.Ident(v)));
            function.Body = function2Value[function.Name].Gamma(invars);
            function.Emit(tt, 0);
            tt.Close();
        }

        public string outputDataPoint(dataPoint p)
        {
            string funcName = p.functionName;
            List<int> attrVals = p.value;
            string ret = funcName;
            foreach (var exFunc in existentialFunctions)
            {
                if (exFunc.Key.Equals(funcName))
                {
                    foreach (var x in attrVals)
                    {
                        ret += "," + x.ToString();
                    }
                }
                else
                {
                    foreach (var arg in exFunc.Value.InParams)
                    {
                        ret += ",?";
                    }
                }
            }
            return ret;
        }


        public List<Dictionary<string, Interval>> transferRS2Interval(Expr rs)
        {
            List<Dictionary<string, Interval>> res = new List<Dictionary<string, Interval>>();
            NAryExpr rsExpr = rs as NAryExpr;
            if (rsExpr == null)
            {
                return res;
            }
            
            string opName = rsExpr.Fun.FunctionName;
            if (opName.Equals("||"))  // each disjunction is an interval example
            {
                res.AddRange(transferRS2Interval(rsExpr.Args[0]));
                res.AddRange(transferRS2Interval(rsExpr.Args[1]));
            }
            else
            {
                // Dictionary<string, Interval> var2Interval = transferSingleRS2Interval(rs);
                // if (var2Interval != null)
                // {
                //     res.Add(var2Interval);
                // }
                List<Dictionary<string, Interval>> var2Intervals = resolveRSIntervals(rsExpr);
                if (var2Intervals.Count > 0)
                {
                    res.AddRange(var2Intervals);
                }
            }

            return res;

            var func = existentialFunctions["b1"];
            List<Variable> vars = func.InParams;
        }


        public List<Dictionary<string, Interval>> resolveRSIntervals(NAryExpr naryExpr)
        {
            List<Dictionary<string, Interval>> res = new List<Dictionary<string, Interval>>();
            
            // resolver atom exprs by "&&"
            List<Expr> atoms = resolveAtoms(naryExpr);

            // first round: handle those without x+/-y, get an interval
            Dictionary<string, Interval> var2Interval = new Dictionary<string, Interval>();
            foreach (string var in vars4IDT)
            {
                var2Interval.Add(var, new Interval());
            }

            List<Expr> copyAtoms = new List<Expr>(atoms);
            foreach (Expr atom in atoms)
            {
                Dictionary<string, Interval> curInterval = transferSingleRS2Interval(atom, var2Interval);
                if (curInterval != null)
                {
                    var2Interval = curInterval;
                    copyAtoms.Remove(atom);
                }
            }
            res.Add(var2Interval);
            // second round: handle those with x+/-y, get a list of intervals
            foreach (Expr atom in copyAtoms)
            {
                List<Dictionary<string, Interval>> curIntervals = transferComplexRS2Intervals(atom, res);
                if (curIntervals.Count > 0)
                {
                    res.Clear();
                    res = curIntervals;
                }
            }

            return res;
        }


        public List<Expr> resolveAtoms(NAryExpr naryExpr)
        {
            List<Expr> atoms = new List<Expr>();
            if (naryExpr == null)
                return atoms;
            string opName = naryExpr.Fun.FunctionName;
            if (opName.Equals("&&"))
            {
                atoms.AddRange(resolveAtoms(naryExpr.Args[0] as NAryExpr));
                atoms.AddRange(resolveAtoms(naryExpr.Args[1] as NAryExpr));
            }
            else
            {
                atoms.Add(naryExpr);
            }
            return atoms;
        }


        public Dictionary<string, Interval> transferSingleRS2Interval(Expr expr, Dictionary<string, Interval> var2Interval)
        {
            NAryExpr naryExpr = expr as NAryExpr;
            if (naryExpr == null)
            {
                return null;
            }
            // if (var2Interval == null)
            // {
            //     var2Interval = new Dictionary<string, Interval>();
            //     foreach (string var in vars4IDT)
            //     {
            //         var2Interval.Add(var, new Interval());
            //     }
            // }
            
            string opName = naryExpr.Fun.FunctionName;
            // if (opName.Equals("&&"))
            // {
            //     Dictionary<string, Interval> interval = transferSingleRS2Interval(naryExpr.Args[0], var2Interval);
            //     if (interval == null)
            //     {
            //         return null;
            //     }
            //     Dictionary<string, Interval> res = transferSingleRS2Interval(naryExpr.Args[1], interval);
            //     return res;
            // }
            // else
            // {
                List<Expr> exprArgs = new List<Expr>(naryExpr.Args);
                if (!(exprArgs[0] is IdentifierExpr) && !(exprArgs[1] is IdentifierExpr))
                {
                    return null;
                }
                if (exprArgs[0] is LiteralExpr)  // transfer the constant to the right
                {
                    switch (opName)
                    {
                        case "<=":
                        {
                            opName = ">=";
                            var tmp = exprArgs[0];
                            exprArgs[0] = exprArgs[1];
                            exprArgs[1] = tmp;
                            break;
                        }
                        case "<":
                        {
                            opName = ">";
                            var tmp = exprArgs[0];
                            exprArgs[0] = exprArgs[1];
                            exprArgs[1] = tmp;
                            break;
                        }
                        case ">=":
                        {
                            opName = "<=";
                            var tmp = exprArgs[0];
                            exprArgs[0] = exprArgs[1];
                            exprArgs[1] = tmp;
                            break;
                        }
                        case ">":
                        {
                            opName = "<";
                            var tmp = exprArgs[0];
                            exprArgs[0] = exprArgs[1];
                            exprArgs[1] = tmp;
                            break;
                        }
                        
                        default: break;
                    }
                }

                if (exprArgs[1] is LiteralExpr)
                {
                    LiteralExpr constantExpr = exprArgs[1] as LiteralExpr;
                    int constant = constantExpr.asBigNum.ToIntSafe;
                    int leftbound = -1000000;
                    int rightbound = 1000000;
                    switch (opName)
                    {
                        case "<=":
                            rightbound = Math.Min(rightbound, constant);
                            break;
                        case "<":
                            rightbound = Math.Min(rightbound, constant - 1);
                            break;
                        case ">=":
                            leftbound = Math.Max(leftbound, constant);
                            break;
                        case ">":
                            leftbound = Math.Max(leftbound, constant + 1);
                            break;
                        
                        default: break;
                    }
                    IdentifierExpr varExpr = exprArgs[0] as IdentifierExpr;
                    if (varExpr == null)
                    {
                        return null;
                    }

                    string var = varExpr.Name;
                    var2Interval[var].setBound(leftbound, rightbound);
                    return var2Interval;
                }
            // }
            
            return null;
        }


        // handle rs like x +/- y cmp c
        public List<Dictionary<string, Interval>> transferComplexRS2Intervals(Expr expr,
            List<Dictionary<string, Interval>> var2Intervals)
        {
            List<Dictionary<string, Interval>> res = new List<Dictionary<string, Interval>>();
            NAryExpr naryExpr = expr as NAryExpr;
            if (naryExpr == null)
                return res;
            string opName = naryExpr.Fun.FunctionName;
            List<Expr> exprArgs = new List<Expr>(naryExpr.Args);
            if (exprArgs[0] is LiteralExpr)  // transfer the constant to the right
            {
                switch (opName)
                {
                    case "<=":
                    {
                        opName = ">=";
                        var tmp = exprArgs[0];
                        exprArgs[0] = exprArgs[1];
                        exprArgs[1] = tmp;
                        break;
                    }
                    case "<":
                    {
                        opName = ">";
                        var tmp = exprArgs[0];
                        exprArgs[0] = exprArgs[1];
                        exprArgs[1] = tmp;
                        break;
                    }
                    case ">=":
                    {
                        opName = "<=";
                        var tmp = exprArgs[0];
                        exprArgs[0] = exprArgs[1];
                        exprArgs[1] = tmp;
                        break;
                    }
                    case ">":
                    {
                        opName = "<";
                        var tmp = exprArgs[0];
                        exprArgs[0] = exprArgs[1];
                        exprArgs[1] = tmp;
                        break;
                    }
                        
                    default: break;
                }
            }
            
            NAryExpr lhsExpr = exprArgs[0] as NAryExpr;
            if (lhsExpr == null)
                return res;
            LiteralExpr constantExpr = exprArgs[1] as LiteralExpr;
            if (constantExpr == null)
                return res;
            int rhs = constantExpr.asBigNum.ToIntSafe;
            foreach (var var2Interval in var2Intervals)
            {
                string lhsOP = lhsExpr.Fun.FunctionName;
                IdentifierExpr var1 = lhsExpr.Args[0] as IdentifierExpr;
                IdentifierExpr var2 = lhsExpr.Args[1] as IdentifierExpr;
                if (var1 == null || var2 == null)
                    return res;
                Interval xInterval = var2Interval[var1.Name];
                Interval yInterval = var2Interval[var2.Name];
                int xl = xInterval.leftbound;
                int xr = xInterval.rightbound;
                int yl = yInterval.leftbound;
                int yr = yInterval.rightbound;
                if (lhsOP == "+")
                {
                    if (yl != yr)
                    {
                        // set x value, get y interval
                        int x0 = 0;
                        if (xl > -1000000)
                            x0 = xl;
                        else if (xr < 1000000)
                            x0 = xr;
                        int ybound = rhs - x0;
                        switch (opName)
                        {
                            case "<=":
                                yr = Math.Min(yr, ybound);
                                break;
                            case "<":
                                yr = Math.Min(yr, ybound - 1);
                                break;
                            case ">=":
                                yl = Math.Max(yl, ybound);
                                break;
                            case ">":
                                yl = Math.Max(yl, ybound + 1);
                                break;
                            
                            default: break;
                        }
                        Dictionary<string, Interval> newdict1 = new Dictionary<string, Interval>(var2Interval);
                        var newxInterval1 = new Interval(x0, x0);
                        var newyInterval1 = new Interval(yl, yr);
                        newdict1[var1.Name] = newxInterval1;
                        newdict1[var2.Name] = newyInterval1;
                        res.Add(newdict1);
                    }

                    if (xl != xr)
                    {
                        // set y value, get x interval
                        yl = yInterval.leftbound;
                        yr = yInterval.rightbound;
                        int y0 = 0;
                        if (yl > -1000000)
                            y0 = yl;
                        else if (yr < 1000000)
                            y0 = yr;
                        int xbound = rhs - y0;
                        switch (opName)
                        {
                            case "<=":
                                xr = Math.Min(xr, xbound);
                                break;
                            case "<":
                                xr = Math.Min(xr, xbound - 1);
                                break;
                            case ">=":
                                xl = Math.Max(xl, xbound);
                                break;
                            case ">":
                                xl = Math.Max(xl, xbound + 1);
                                break;
                            
                            default: break;
                        }
                        Dictionary<string, Interval> newdict2 = new Dictionary<string, Interval>(var2Interval);
                        var newxInterval2 = new Interval(xl, xr);
                        var newyInterval2 = new Interval(y0, y0);
                        newdict2[var1.Name] = newxInterval2;
                        newdict2[var2.Name] = newyInterval2;
                        res.Add(newdict2);
                    }
                }
                else if (lhsOP == "-")
                {
                    // set x value, get y interval
                    int x0 = 0;
                    if (xl > -1000000)
                        x0 = xl;
                    else if (xr < 1000000)
                        x0 = xr;
                    int ybound = x0 - rhs;
                    switch (opName)  // flip the sign
                    {
                        case "<=":
                            yl = Math.Max(yl, ybound);
                            break;
                        case "<":
                            yl = Math.Max(yl, ybound + 1);
                            break;
                        case ">=":
                            yr = Math.Min(yr, ybound);
                            break;
                        case ">":
                            yr = Math.Min(yr, ybound - 1);
                            break;
                        
                        default: break;
                    }
                    Dictionary<string, Interval> newdict1 = new Dictionary<string, Interval>(var2Interval);
                    var newxInterval1 = new Interval(x0, x0);
                    var newyInterval1 = new Interval(yl, yr);
                    newdict1[var1.Name] = newxInterval1;
                    newdict1[var2.Name] = newyInterval1;
                    res.Add(newdict1);
                    
                    // set y value, get x interval
                    yl = yInterval.leftbound;
                    yr = yInterval.rightbound;
                    int y0 = 0;
                    if (yl > -1000000)
                        y0 = yl;
                    else if (yr < 1000000)
                        y0 = yr;
                    int xbound = rhs + y0;
                    switch (opName)
                    {
                        case "<=":
                            xr = Math.Min(xr, xbound);
                            break;
                        case "<":
                            xr = Math.Min(xr, xbound - 1);
                            break;
                        case ">=":
                            xl = Math.Max(xl, xbound);
                            break;
                        case ">":
                            xl = Math.Max(xl, xbound + 1);
                            break;
                        
                        default: break;
                    }
                    Dictionary<string, Interval> newdict2 = new Dictionary<string, Interval>(var2Interval);
                    var newxInterval2 = new Interval(xl, xr);
                    var newyInterval2 = new Interval(y0, y0);
                    newdict2[var1.Name] = newxInterval2;
                    newdict2[var2.Name] = newyInterval2;
                    res.Add(newdict2);
                }
            }
            return res;
        }
        
        

        public string outputIntervalDataWithLabel(List<Dictionary<string, Interval>> var2Intervals)
        {
            string res = "";
            foreach (var var2Interval in var2Intervals)
            {
                res += "b1";
                foreach (var var in vars4IDT)
                {
                    string l = var2Interval[var].leftbound.ToString();
                    string r = var2Interval[var].rightbound.ToString();
                    res = res + ",(" + l + "," + r + ")";
                }
                res += ",false\n";
            }

            return res;
        }
        

        /*
        public void RecordCounterExamples2File(Tuple<List<Tuple<string, List<Model.Element>>>, List<Tuple<string, List<Model.Element>>>> cex)
        {
            List<Tuple<string, List<Model.Element>>> lhs = cex.Item1;
            List<Tuple<string, List<Model.Element>>> rhs = cex.Item2;

            string ret = "";
            
            if (lhs.Count == 0)
            {
                Debug.Assert(rhs.Count == 1);
                ret += ParseListOfModel(rhs.ElementAt(0).Item2);
                ret += ";accept";
            }
            else if (rhs.Count == 0)
            {
                Debug.Assert(lhs.Count == 1);
                ret += ParseListOfModel(lhs.ElementAt(0).Item2);
                ret += ";reject";
            }
            else
            {
                Debug.Assert(lhs.Count == 1);
                Debug.Assert(rhs.Count == 1);
                ret += ParseListOfModel(lhs.ElementAt(0).Item2);
                ret += ";antecedent\n";
                ret += ParseListOfModel(rhs.ElementAt(0).Item2);
                ret += ";consequent";
            }
            if (!System.IO.File.Exists("samples.txt"))
            {
                // Create a file to write to. 
                using (System.IO.StreamWriter sw = System.IO.File.CreateText("samples.txt"))
                {
                    sw.WriteLine("// x y -- empty line");                    
                }
            }

            // This text is always added, making the file longer over time 
            // if it is not deleted. 
            using (System.IO.StreamWriter sw = System.IO.File.AppendText("samples.txt"))
            {                
                sw.WriteLine(ret);
            }
            return;
        }
         * */

#if C5                
        public void RecordCexForC5(Tuple<List<Tuple<string, List<Model.Element>>>, List<Tuple<string, List<Model.Element>>>> cex, 
                                                                                    bool recordImplications = true)
        {
            List<Tuple<string, List<Model.Element>>> lhs = cex.Item1;
            List<Tuple<string, List<Model.Element>>> rhs = cex.Item2;

            if (lhs.Count == 0)
            {
                // positive sample
                Debug.Assert(rhs.Count == 1);
                
                dataPoint argsval = new dataPoint(rhs.ElementAt(0).Item1, rhs.ElementAt(0).Item2);
                if (!CommandLineOptions.Clo.RSInfer)
                {
                    int dis = argsval.value.Select(x => Math.Abs(x)).Max();
                    if(dis > currentReuseMax) currentReuseMax = dis;
                }
                if (this.c5samplePointToIndex.ContainsKey(argsval))
                {
                    Debug.Assert(c5samplePointToClassAttr[argsval] != 2); // should be unknown
                    this.c5samplePointToClassAttr[argsval] = 1;
                    if (CommandLineOptions.Clo.Trace)
                    {
                        Console.WriteLine("Overwrote: " + argsval.print() + ": positive");
                    }
                }
                else
                {
                    c5samplePointToIndex[argsval] = c5DataPointsIndex;
                    c5DataPointsIndex++;
                    c5samplePointToClassAttr[argsval] = 1;
                    int maxVal = argsval.maxAbs();
                    c5sampleMaxAbs = Math.Max(c5sampleMaxAbs, maxVal);
                    if (CommandLineOptions.Clo.Trace)
                    {
                        Console.WriteLine("Added: " + argsval.print() + ": positive");
                    }
                }

                terminatingStateSamplesSet.Add(argsval);
            }
            else if (rhs.Count == 0)
            {
                if(lhs.Count > 1)
                {
                    List<Tuple<string, List<Model.Element>>> newlhs = new List<Tuple<string, List<Model.Element>>>();
                    newlhs.Add(lhs.ElementAt(lhs.Count - 1));
                    lhs = newlhs;
                }
                Debug.Assert(lhs.Count == 1);
                
                dataPoint argsval = new dataPoint(lhs.ElementAt(0).Item1, lhs.ElementAt(0).Item2);
                if (!CommandLineOptions.Clo.RSInfer)
                {
                    int dis = argsval.value.Select(x => Math.Abs(x)).Max();
                    if(dis > currentReuseMax) currentReuseMax = dis;
                }
                if (c5samplePointToIndex.ContainsKey(argsval))
                {
                    Debug.Assert(c5samplePointToClassAttr[argsval] != 1); // should be unknown
                    c5samplePointToClassAttr[argsval] = 2;
                    if (CommandLineOptions.Clo.Trace)
                    {
                        Console.WriteLine("Overwrote: " + argsval.print() + ": negative");
                    }
                }
                else
                {
                    c5samplePointToIndex[argsval] = c5DataPointsIndex;
                    c5DataPointsIndex++;
                    c5samplePointToClassAttr[argsval] = 2;
                    int maxVal = argsval.maxAbs();
                    c5sampleMaxAbs = Math.Max(c5sampleMaxAbs, maxVal);
                    if (CommandLineOptions.Clo.Trace)
                    {
                        Console.WriteLine("Added: " + argsval.print() + ": negative");
                    }
                }
            }
            else
            {
                if (lhs.Count > 1)
                {
                    List<Tuple<string, List<Model.Element>>> newlhs = new List<Tuple<string, List<Model.Element>>>();
                    newlhs.Add(lhs.ElementAt(lhs.Count - 1));
                    lhs = newlhs;
                }
                Debug.Assert(lhs.Count == 1);
                Debug.Assert(rhs.Count == 1);
                
                int antecedent, consequent;

                dataPoint argsval1 = new dataPoint(lhs.ElementAt(0).Item1, lhs.ElementAt(0).Item2);
                dataPoint argsval2 = new dataPoint(rhs.ElementAt(0).Item1, rhs.ElementAt(0).Item2);
                if (!CommandLineOptions.Clo.RSInfer)
                {
                    int dis1 = argsval1.value.Select(x => Math.Abs(x)).Max();
                    if(dis1 > currentReuseMax) currentReuseMax = dis1;
                    int dis2 = argsval2.value.Select(x => Math.Abs(x)).Max();
                    if(dis2 > currentReuseMax) currentReuseMax = dis2;
                }

                if (c5samplePointToIndex.ContainsKey(argsval1))
                {
                    //Debug.Assert(C5samplePointToClassAttr[argsval1] == 0); // is unknown
                    antecedent = c5samplePointToIndex[argsval1];                    
                }
                else
                {
                    c5samplePointToIndex[argsval1] = c5DataPointsIndex;
                    antecedent = c5DataPointsIndex;
                    c5DataPointsIndex++;
                    c5samplePointToClassAttr[argsval1] = 0;
                    int maxVal = argsval1.maxAbs();
                    c5sampleMaxAbs = Math.Max(c5sampleMaxAbs, maxVal);
                }
                if (c5samplePointToIndex.ContainsKey(argsval2))
                {
                    //Debug.Assert(C5samplePointToClassAttr[argsval2] == 0); // is unknown
                    consequent = c5samplePointToIndex[argsval2];                    
                }
                else
                {
                    c5samplePointToIndex[argsval2] = c5DataPointsIndex;
                    consequent = c5DataPointsIndex;
                    c5DataPointsIndex++;
                    c5samplePointToClassAttr[argsval2] = 0;
                    int maxVal = argsval2.maxAbs();
                    c5sampleMaxAbs = Math.Max(c5sampleMaxAbs, maxVal);
                }
                
                // add the consequent
                // if the antecedent is in it
                if (terminatingStateSamplesSet.Contains(argsval1))
                    terminatingStateSamplesSet.Add(argsval2);
                
                if (recordImplications)
                {
                    Tuple<int, int> t = new Tuple<int, int>(antecedent, consequent);
                    if (CommandLineOptions.Clo.Trace)
                    {
                        Console.WriteLine("Added implication: " + antecedent + "," + consequent);
                    }
                    c5implications.Add(t);
                    if (CommandLineOptions.Clo.RSInfer)
                    {
                        if (!implicationDictionary.ContainsKey(argsval1))
                        {
                            implicationDictionary.Add(argsval1, new HashSet<dataPoint>{argsval2});
                        }
                        else
                        {
                            HashSet<dataPoint> set = implicationDictionary[argsval1];
                            set.Add(argsval2);
                        }
                    }
                }
            }

            if (!CommandLineOptions.Clo.RSInfer)
            {
                // currentPosReused = 0;
                while(currentPosReusedIndex < posReuseList.Count())
                {
                    // var dis = posReuseList[currentPosReused].value.Select(x => Math.Abs(x)).Max();
                    // if(dis > currentReuseMax) break;
                    if(posReuseNum >= max_abslute_size && posReuseNum >= c5samplePointToIndex.Count()/max_relative_size)
                        break;
                    var reuseSample = posReuseList[currentPosReusedIndex];
                    // if (CommandLineOptions.Clo.dataShare && reuseSample.maxAbs() >= 2 * c5sampleMaxAbs)
                    if (reuseSample.maxAbs() >= 2 * c5sampleMaxAbs)
                    {
                        currentPosReusedIndex += 1;
                        continue;
                    }
                    if(!c5samplePointToIndex.ContainsKey(reuseSample))
                    {
                        c5samplePointToIndex[reuseSample] = c5DataPointsIndex++;
                        c5samplePointToClassAttr[reuseSample] = 1; // Pos
                    }
                    currentPosReusedIndex += 1;
                    posReuseNum += 1;
                }
                // currentNegReused = 0;
                while(currentNegReusedIndex < negReuseList.Count())
                {
                    // var dis = negReuseList[currentNegReused].value.Select(x => Math.Abs(x)).Max();
                    // if(dis > currentReuseMax) break;
                    if(negReuseNum >= max_abslute_size && negReuseNum >= c5samplePointToIndex.Count()/max_relative_size)
                        break;
                    var reuseSample = negReuseList[currentNegReusedIndex];
                    if (reuseSample.maxAbs() >= 2 * c5sampleMaxAbs)
                    {
                        currentNegReusedIndex += 1;
                        continue;
                    }
                    if(!c5samplePointToIndex.ContainsKey(reuseSample))
                    {
                        c5samplePointToIndex[reuseSample] = c5DataPointsIndex++;
                        c5samplePointToClassAttr[reuseSample] = 2; // Neg
                    }
                    currentNegReusedIndex += 1;
                    negReuseNum += 1;
                }
                // currentImpReused = 0;
                while(currentImpReusedIndex < impReuseList.Count())
                {
                    // var dis1 = impReuseList[currentImpReused].Item1.value.Select(x => Math.Abs(x)).Max();
                    // var dis2 = impReuseList[currentImpReused].Item2.value.Select(x => Math.Abs(x)).Max();
                    // if(dis1 > currentReuseMax || dis2 > currentReuseMax) break;
                    if(impReuseNum >= max_abslute_size && impReuseNum >= c5samplePointToIndex.Count()/max_relative_size)
                        break;
                    var reuseImp = impReuseList[currentImpReusedIndex];
                    if (reuseImp.Item1.maxAbs() >= 2 * c5sampleMaxAbs || reuseImp.Item2.maxAbs() >= 2 * c5sampleMaxAbs)
                    {
                        currentImpReusedIndex += 1;
                        continue;
                    }
                    if(!c5samplePointToIndex.ContainsKey(reuseImp.Item1))
                    {
                        c5samplePointToIndex[reuseImp.Item1] = c5DataPointsIndex++;
                        c5samplePointToClassAttr[reuseImp.Item1] = 0; // Unknown
                    }
                    if(!c5samplePointToIndex.ContainsKey(reuseImp.Item2))
                    {
                        c5samplePointToIndex[reuseImp.Item2] = c5DataPointsIndex++;
                        c5samplePointToClassAttr[reuseImp.Item2] = 0; // Unknown
                    }
                    Tuple<int, int> t = new Tuple<int, int>(c5samplePointToIndex[reuseImp.Item1], c5samplePointToIndex[reuseImp.Item2]);
                    if(!c5implications.Contains(t)) c5implications.Add(t);
                    currentImpReusedIndex += 1;
                    impReuseNum += 1;
                }
                Console.WriteLine("[Debug0] " + posReuseNum.ToString() + " Pos, " + negReuseNum.ToString() + " Neg, " + impReuseNum.ToString() + " Impl Reused.");
            }
            else
            { // _ADD_reuse
                if (CommandLineOptions.Clo.dataShare)
                {
                    // reuse term samples
                    while (rs_currentTermReusedIndex < storage_term_samples.Count())
                    {
                        // if (rs_currentTermReused >= condterm_max_abslute_size &&
                        //     rs_currentTermReused >= c5samplePointToIndex.Count() / condterm_max_ratio)
                        //     break;
                        if (rs_TermReusedNum >= c5samplePointToIndex.Count() / condterm_max_ratio)
                            break;
                        var reuseSample = storage_term_samples[rs_currentTermReusedIndex];
                        if (reuseSample.maxAbs() >= 2 * c5sampleMaxAbs)
                        {
                            rs_currentTermReusedIndex += 1;
                            continue;
                        }
                        if (!c5samplePointToIndex.ContainsKey(reuseSample))
                        {
                            c5samplePointToIndex[reuseSample] = c5DataPointsIndex++;
                            c5samplePointToClassAttr[reuseSample] = 2; // Neg
                        }

                        rs_currentTermReusedIndex += 1;
                        rs_TermReusedNum += 1;
                    }
                    // reuse imp samples
                    while (rs_currentImpReusedIndex < storage_imp.Count())
                    {
                        if (rs_ImpReusedNum >= c5samplePointToIndex.Count() / condterm_max_ratio)
                            break;
                        var imp_sample = storage_imp[rs_currentImpReusedIndex];
                        if (imp_sample.Item1.maxAbs() >= 2 * c5sampleMaxAbs ||
                            imp_sample.Item2.maxAbs() >= 2 * c5sampleMaxAbs)
                        {
                            rs_currentImpReusedIndex += 1;
                            continue;
                        }
                        if (!c5samplePointToIndex.ContainsKey(imp_sample.Item1))
                        {
                            c5samplePointToIndex[imp_sample.Item1] = c5DataPointsIndex++;
                            c5samplePointToClassAttr[imp_sample.Item1] = 0; // Unknown
                        }
                        if(!c5samplePointToIndex.ContainsKey(imp_sample.Item2))
                        {
                            c5samplePointToIndex[imp_sample.Item2] = c5DataPointsIndex++;
                            c5samplePointToClassAttr[imp_sample.Item2] = 0; // Unknown
                        }
                        Tuple<int, int> t = new Tuple<int, int>(c5samplePointToIndex[imp_sample.Item1], c5samplePointToIndex[imp_sample.Item2]);
                        if(!c5implications.Contains(t)) c5implications.Add(t);
                        rs_currentImpReusedIndex += 1;
                        rs_ImpReusedNum += 1;
                    }
                    Console.WriteLine("[Debug] " + rs_TermReusedNum.ToString() + " Term, " + rs_ImpReusedNum.ToString() + " Imp Reused.");
                }
                
                // // reuse oldold
                // while(currentMDataReused < mDataList.Count())
                // {
                //     if(currentMDataReused >= max_abslute_size && currentMDataReused >= c5samplePointToIndex.Count()/condterm_max_ratio)
                //         break;
                //     if(!c5samplePointToIndex.ContainsKey(mDataList[currentMDataReused]))
                //     {
                //         c5samplePointToIndex[mDataList[currentMDataReused]] = c5DataPointsIndex++;
                //         c5samplePointToClassAttr[mDataList[currentMDataReused]] = 2; // Neg
                //     }
                //     currentMDataReused += 1;
                // }
                // old reuse --- randomly reuse
                // if (CommandLineOptions.Clo.dataShare)
                // {
                //     // randomly reuse
                //     if(currentMDataReused < mDataList.Count())
                //     {
                //         // get reuse size
                //         int maxReuseSize = Math.Max(max_abslute_size, c5samplePointToIndex.Count() / condterm_max_ratio);
                //         if (currentMDataReused < maxReuseSize)
                //         {
                //             int toReuseSize = maxReuseSize - currentMDataReused;
                //             // get reuse indexes
                //             List<int> toReuseIndexes = new List<int>();
                //             if (toReuseSize >= mDataList.Count())
                //             {
                //                 for (int i = 0; i < mDataList.Count(); i++)
                //                 {
                //                     toReuseIndexes.Add(i);
                //                 }
                //             }
                //             else
                //             {
                //                 toReuseIndexes = GetRandomNumbers(mDataList.Count(), toReuseSize);
                //             }
                //             // reuse samples
                //             foreach(int index in toReuseIndexes)
                //             {
                //                 if(!c5samplePointToIndex.ContainsKey(mDataList[index]))
                //                 {
                //                     c5samplePointToIndex[mDataList[index]] = c5DataPointsIndex++;
                //                     c5samplePointToClassAttr[mDataList[index]] = 2; // Neg
                //                 }
                //                 Console.WriteLine("[Debug] Reuse ddlt sample:" + mDataList[index].print());
                //                 currentMDataReused += 1;
                //             }
                //         }
                //     }
                //     Console.WriteLine("[Debug] " + currentMDataReused.ToString() +  " MData Reused as Negative Sample.");
                // }
            }
        }

        public List<int> GetRandomNumbers(int count, int reuse)
        {
            Random random = new Random();
            HashSet<int> selectedNumbers = new HashSet<int>();

            while (selectedNumbers.Count < reuse)
            {
                int num = random.Next(count); // 随机生成0到count-1之间的数
                if (!indexReused.Contains(num))
                {
                    selectedNumbers.Add(num);     // 如果已经存在则不会添加
                    indexReused.Add(num);
                }
            }

            return new List<int>(selectedNumbers);
        }

        public void generateC5Files()
        {
            string dataFile = "";
            string implicationsFile = "";

            foreach (var model in c5samplePointToClassAttr.Keys)
            {
                dataFile += outputDataPoint(model);
                switch (c5samplePointToClassAttr[model])
                {
                    case 0: dataFile += ",?\n"; break;
                    case 1: dataFile += ",true\n"; break;
                    case 2: dataFile += ",false\n"; break;

                    default: Debug.Assert(false); break;
                }
            }

            foreach (var implication in c5implications)
            {
                implicationsFile += implication.Item1;
                implicationsFile += " ";
                implicationsFile += implication.Item2;
                implicationsFile += "\n";
            }

            using (System.IO.StreamWriter sw = System.IO.File.CreateText(filename + ".data"))
            {
                sw.WriteLine(dataFile);
                sw.Flush();
            }
            using (System.IO.StreamWriter sw = System.IO.File.CreateText(filename + ".implications"))
            {
                sw.WriteLine(implicationsFile);
            }
            
            return;
        }

#endif

        public void AddCounterExample(Tuple<List<Tuple<string, List<Model.Element>>>, List<Tuple<string, List<Model.Element>>>> cex, 
                                                                                                                bool recordImplications = true)
        {
            List<Tuple<string, List<Model.Element>>> lhs = cex.Item1;
            List<Tuple<string, List<Model.Element>>> rhs = cex.Item2;

            //counterExamples.Add(cex);
#if true
            if (lhs.Count > 0 && rhs.Count > 0)
            {
                this.numImplications++;
                if(recordImplications && CommandLineOptions.Clo.Trace) 
                    Console.WriteLine("Implication added");
                else if (CommandLineOptions.Clo.Trace)
                    Console.WriteLine("Implication points added as unknowns (no edge added!)");                
            }
            else if (lhs.Count > 0)
            {
                this.numNegCounterExamples++;
                if (CommandLineOptions.Clo.Trace)
                    Console.WriteLine("Negative example added");
            }
            else
            {
                this.numPosExamples++;
                if (CommandLineOptions.Clo.Trace)
                    Console.WriteLine("Positive example added");
            }
#endif

#if C5
            RecordCexForC5(cex, recordImplications);
#endif
        }
        
#if Pranav
        public bool HandleCounterExample(string impl, Counterexample error, out bool counterExampleAdded)
        {
            // return true if a true error encountered.
            // return false if the error is due to a wrong choice of current conjecture.
            counterExampleAdded = false;

            VCisValid = false;
            var cex = P_ExtractState(impl, error);

            // the counter-example does not involve any existential function ==> Is a real counter-example !
            if (cex.Item1.Count == 0 && cex.Item2.Count == 0)
            {
                realErrorEncountered = true;
                return true;
            }
            if (!newSamplesAdded || (cex.Item1.Count == 1 && cex.Item2.Count == 0) || (cex.Item2.Count == 1 && cex.Item1.Count == 0))
            {
                AddCounterExample(cex);
                counterExampleAdded = true;
            }
            newSamplesAdded = true;          
            return false;
        }
#endif

        public bool HandleCounterExample(string impl, Counterexample error, out bool cexAdded)
        {
            // return true if a true error encountered.
            // return false if the error is due to a wrong choice of current conjecture.
            VCisValid = false;
            var cex = P_ExtractState(impl, error);

            // the counter-example does not involve any existential function ==> Is a real counter-example !
            if (cex.Item1.Count == 0 && cex.Item2.Count == 0)
            {
                //realErrorEncountered = true;
                cexAdded = false;
                return true;
            }

            if (cex.Item1.Count == 0 || cex.Item2.Count == 0)
            {
                cexAdded = true;
                AddCounterExample(cex);
                return false;
            }
            else
            {
                cexAdded = false;
                implicationCounterExamples.Add(cex);
                return false;
            }
        }

        public bool learn(out HashSet<string> funcsChanged)
        {
            funcsChanged = null;

            // Call C5 on the names/data file
            generateC5Files();

            var start = DateTime.Now;
            var inc = start - start;

            // Prepare the C5 process to run
            ProcessStartInfo process = new ProcessStartInfo();
            //process.FileName = "C:\\work\\machine learning\\svn\\C50\\c5.0." + this.config;
            process.FileName = "./c5.0." + this.config;
            //process.FileName = "c5.0dbg";
            //process.FileName = "C:\\work\\Strand\\svn\\Strand\\Boogie\\Binaries\\c5.0";
            //process.FileName = "..\\..\\..\\Binaries\\c5.0";
            process.Arguments = "-I 1 -m 1 -f " + filename;
            if (CommandLineOptions.Clo.Trace)
            {
                Console.WriteLine("c5 filename: " + process.FileName);
            }
            process.WindowStyle = ProcessWindowStyle.Hidden;
            process.CreateNoWindow = true;
            process.UseShellExecute = false;
            process.RedirectStandardOutput = true;

            // Run the external process & wait for it to finish
            Process proc = Process.Start(process);
            string output = proc.StandardOutput.ReadToEnd();
            proc.WaitForExit();
            inc = (DateTime.Now - start);
            c5LearnerTime += inc;
            c5LearnerQueries++;

            // Retrieve the app's exit code
            int exitCode = proc.ExitCode;
            if (exitCode < 0)
            {
                Console.WriteLine("The learner seems to have run into an error!");
                return false;
            }                            

            if (CommandLineOptions.Clo.Trace)
                Console.WriteLine("Learner (c5) Time taken = " + inc.TotalSeconds.ToString());

            start = DateTime.Now;
            
            string c5JSONTree = System.IO.File.ReadAllText(filename + ".json");

            funcsChanged = new HashSet<string>();
            // extract the value for the existential functions from the model.            
            C5TreeNode root = JsonConvert.DeserializeObject<C5TreeNode>(c5JSONTree);
            //Debug.Assert(root.attribute.Equals(pcAttrName));

            foreach (var functionName in function2Value.Keys)
            {
                if (function2Value[functionName].constructModel(functionName, root, attribute2Expr, functionID))
                    funcsChanged.Add(functionName);
            }
            this.jsontime += (DateTime.Now - start);

            if (funcsChanged.Count() == 0)
                return false;

            return true;
            //Debug.Assert(funcsChanged.Count > 0);            
        }



        private List<Tuple<string, List<Model.Element>>> ExtractState(string impl, Counterexample error)
        {
            var lastBlock = error.Trace.Last() as Block;
            AssertCmd failingAssert = null;

            CallCounterexample callCounterexample = error as CallCounterexample;
            if (callCounterexample != null)
            {
                Procedure failingProcedure = callCounterexample.FailingCall.Proc;
                Requires failingRequires = callCounterexample.FailingRequires;
                failingAssert = lastBlock.Cmds.OfType<AssertRequiresCmd>().FirstOrDefault(ac => ac.Requires == failingRequires);
            }
            ReturnCounterexample returnCounterexample = error as ReturnCounterexample;
            if (returnCounterexample != null)
            {
                Ensures failingEnsures = returnCounterexample.FailingEnsures;
                failingAssert = lastBlock.Cmds.OfType<AssertEnsuresCmd>().FirstOrDefault(ac => ac.Ensures == failingEnsures);
            }
            AssertCounterexample assertCounterexample = error as AssertCounterexample;
            if (assertCounterexample != null)
            {
                failingAssert = lastBlock.Cmds.OfType<AssertCmd>().FirstOrDefault(ac => ac == assertCounterexample.FailingAssert);
            }

            Debug.Assert(failingAssert != null);
            return ExtractState(impl, failingAssert.Expr, error.Model);
        }

        private Tuple<List<Tuple<string, List<Model.Element>>>, List<Tuple<string, List<Model.Element>>>> P_ExtractState(string impl, Counterexample error)
        {
            var lastBlock = error.Trace.Last() as Block;
            AssertCmd failingAssert = null;

            CallCounterexample callCounterexample = error as CallCounterexample;
            if (callCounterexample != null)
            {
                Procedure failingProcedure = callCounterexample.FailingCall.Proc;
                Requires failingRequires = callCounterexample.FailingRequires;
                failingAssert = lastBlock.Cmds.OfType<AssertRequiresCmd>().FirstOrDefault(ac => ac.Requires == failingRequires);
            }
            ReturnCounterexample returnCounterexample = error as ReturnCounterexample;
            if (returnCounterexample != null)
            {
                Ensures failingEnsures = returnCounterexample.FailingEnsures;
                failingAssert = lastBlock.Cmds.OfType<AssertEnsuresCmd>().FirstOrDefault(ac => ac.Ensures == failingEnsures);
            }
            AssertCounterexample assertCounterexample = error as AssertCounterexample;
            if (assertCounterexample != null)
            {
                failingAssert = lastBlock.Cmds.OfType<AssertCmd>().FirstOrDefault(ac => ac == assertCounterexample.FailingAssert);
            }
            Debug.Assert(failingAssert != null);

            // extract the lhs of the returned tuple from the AssumeCmds
            List<Tuple<string, List<Model.Element>>> lhs = new List<Tuple<string, List<Model.Element>>>();
            List<Tuple<string, List<Model.Element>>> rhs = new List<Tuple<string, List<Model.Element>>>();
                
            foreach (var cmd in error.AssumedCmds) 
            {
                AssumeCmd assumeCmd = cmd as AssumeCmd;
                Debug.Assert(assumeCmd != null);
                lhs.AddRange(P_ExtractState(impl, assumeCmd.Expr, error.Model));
            }

            if (failingAssert is RecurrentSetImplyGuardAssertCmd)
            {
                lhs.AddRange(P_ExtractState(impl, failingAssert.Expr, error.Model));
            }
            else
            {
                rhs.AddRange(P_ExtractState(impl, failingAssert.Expr, error.Model));
            }
            return Tuple.Create(lhs, rhs);
        }

        private List<Tuple<string, List<Model.Element>>> P_ExtractState(string impl, Expr expr, Model model)
        {
            /*
            var funcsUsed = P_FunctionCollector.Collect(expr);

            var ret = new List<Tuple<string, List<Model.Element>>>();

            foreach (var fn in funcsUsed)
            {
                var fnName = fn.Name;
                if (!constant2FuncCall.ContainsKey(fnName))
                    continue;

                var func = constant2FuncCall[fnName];
                var funcName = (func.Fun as FunctionCall).FunctionName;
                var vals = new List<Model.Element>();
                prover.Context.BoogieExprTranslator.Translate(func.Args).Iter(ve => vals.Add(getValue(ve, model)));
                ret.Add(Tuple.Create(funcName, vals));
            }
             */
            
            var funcsUsed = FunctionCollector.Collect(expr);

            var ret = new List<Tuple<string, List<Model.Element>>>();

            foreach (var tup in funcsUsed.Where(t => t.Item2 == null))
            {
                var constant = tup.Item1;
                if (!constant2FuncCall.ContainsKey(constant.Name))
                    continue;

                var func = constant2FuncCall[constant.Name];
                var funcName = (func.Fun as FunctionCall).FunctionName;
                var vals = new List<Model.Element>();
                prover.Context.BoogieExprTranslator.Translate(func.Args).Iter(ve => vals.Add(getValue(ve, model)));
                ret.Add(Tuple.Create(funcName, vals));
            }

            foreach (var tup in funcsUsed.Where(t => t.Item2 != null))
            {
                var constant = tup.Item1;
                var boundExpr = tup.Item2;

                if (!constant2FuncCall.ContainsKey(constant.Name))
                    continue;

                // There are some bound variables (because the existential function was inside an \exists).
                // We must find an assignment for bound varibles 

                // First, peice apart the existential functions
                var cd = new Duplicator();
                var tup2 = ExistentialExprModelMassage.Massage(cd.VisitExpr(boundExpr.Body));
                var be = tup2.Item1;
                Expr env = Expr.True;
                foreach (var ahFunc in tup2.Item2)
                {
                    var tup3 = impl2FuncCalls[impl].First(t => t.Item2.Name == ahFunc.Name);
                    var varList = new List<Expr>();
                    tup3.Item3.Args.OfType<Expr>().Iter(v => varList.Add(v));

                    env = Expr.And(env, function2Value[tup3.Item1].Gamma(varList));
                }
                be = Expr.And(be, Expr.Not(env));

                // map formals to constants
                var formalToConstant = new Dictionary<string, Constant>();
                foreach (var f in boundExpr.Dummies.OfType<Variable>())
                    formalToConstant.Add(f.Name, new Constant(Token.NoToken, new TypedIdent(Token.NoToken, f.Name + "@subst@" + (existentialConstCounter++), f.TypedIdent.Type), false));
                be = Substituter.Apply(new Substitution(v => formalToConstant.ContainsKey(v.Name) ? Expr.Ident(formalToConstant[v.Name]) : Expr.Ident(v)), be);
                formalToConstant.Values.Iter(v => prover.Context.DeclareConstant(v, false, null));

                var reporter = new AbstractHoudiniErrorReporter();
                var ve = prover.Context.BoogieExprTranslator.Translate(be);
                prover.Assert(ve, true);
                prover.Check();
                var proverOutcome = prover.CheckOutcomeCore(reporter);
                if (proverOutcome != ProverInterface.Outcome.Invalid)
                    continue;
                model = reporter.model;

                var func = constant2FuncCall[constant.Name];
                var funcName = (func.Fun as FunctionCall).FunctionName;
                var vals = new List<Model.Element>();
                foreach (var funcArg in func.Args.OfType<Expr>())
                {
                    var arg = Substituter.Apply(new Substitution(v => formalToConstant.ContainsKey(v.Name) ? Expr.Ident(formalToConstant[v.Name]) : Expr.Ident(v)), funcArg);
                    vals.Add(getValue(prover.Context.BoogieExprTranslator.Translate(arg), model));
                }
                ret.Add(Tuple.Create(funcName, vals));

            }
            
            return ret;
        }

        private static int existentialConstCounter = 0;

        private List<Tuple<string, List<Model.Element>>> ExtractState(string impl, Expr expr, Model model)
        {
            var funcsUsed = FunctionCollector.Collect(expr);

            var ret = new List<Tuple<string, List<Model.Element>>>();

            foreach (var tup in funcsUsed.Where(t => t.Item2 == null))
            {
                var constant = tup.Item1;
                if (!constant2FuncCall.ContainsKey(constant.Name))
                    continue;

                var func = constant2FuncCall[constant.Name];
                var funcName = (func.Fun as FunctionCall).FunctionName;
                var vals = new List<Model.Element>();
                prover.Context.BoogieExprTranslator.Translate(func.Args).Iter(ve => vals.Add(getValue(ve, model)));
                ret.Add(Tuple.Create(funcName, vals));
            }

            foreach (var tup in funcsUsed.Where(t => t.Item2 != null))
            {
                var constant = tup.Item1;
                var boundExpr = tup.Item2;

                if (!constant2FuncCall.ContainsKey(constant.Name))
                    continue;

                // There are some bound variables (because the existential function was inside an \exists).
                // We must find an assignment for bound varibles 

                // First, peice apart the existential functions
                var cd = new Duplicator();
                var tup2 = ExistentialExprModelMassage.Massage(cd.VisitExpr(boundExpr.Body));
                var be = tup2.Item1;
                Expr env = Expr.True;
                foreach (var ahFunc in tup2.Item2)
                {
                    var tup3 = impl2FuncCalls[impl].First(t => t.Item2.Name == ahFunc.Name);
                    var varList = new List<Expr>();
                    tup3.Item3.Args.OfType<Expr>().Iter(v => varList.Add(v));

                    env = Expr.And(env, function2Value[tup3.Item1].Gamma(varList));
                }
                be = Expr.And(be, Expr.Not(env));

                // map formals to constants
                var formalToConstant = new Dictionary<string, Constant>();
                foreach (var f in boundExpr.Dummies.OfType<Variable>())
                    formalToConstant.Add(f.Name, new Constant(Token.NoToken, new TypedIdent(Token.NoToken, f.Name + "@subst@" + (existentialConstCounter++), f.TypedIdent.Type), false));
                be = Substituter.Apply(new Substitution(v => formalToConstant.ContainsKey(v.Name) ? Expr.Ident(formalToConstant[v.Name]) : Expr.Ident(v)), be);
                formalToConstant.Values.Iter(v => prover.Context.DeclareConstant(v, false, null));

                var reporter = new MLHoudiniErrorReporter();
                var ve = prover.Context.BoogieExprTranslator.Translate(be);
                prover.Assert(ve, true);
                prover.Check();
                var proverOutcome = prover.CheckOutcomeCore(reporter);
                if (proverOutcome != ProverInterface.Outcome.Invalid)
                    continue;
                model = reporter.model;

                var func = constant2FuncCall[constant.Name];
                var funcName = (func.Fun as FunctionCall).FunctionName;
                var vals = new List<Model.Element>();
                foreach (var funcArg in func.Args.OfType<Expr>())
                {
                    var arg = Substituter.Apply(new Substitution(v => formalToConstant.ContainsKey(v.Name) ? Expr.Ident(formalToConstant[v.Name]) : Expr.Ident(v)), funcArg);
                    vals.Add(getValue(prover.Context.BoogieExprTranslator.Translate(arg), model));
                }
                ret.Add(Tuple.Create(funcName, vals));

            }

            return ret;
        }

        private Model.Element getValue(VCExpr arg, Model model)
        {

            if (arg is VCExprLiteral)
            {
                //return model.GetElement(arg.ToString());
                return model.MkElement(arg.ToString());
            }

            else if (arg is VCExprVar)
            {
                var el = model.TryGetFunc(prover.Context.Lookup(arg as VCExprVar));
                if (el != null)
                {
                    Debug.Assert(el.Arity == 0 && el.AppCount == 1);
                    return el.Apps.First().Result;
                }
                else
                {
                    // Variable not defined; assign arbitrary value
                    if (arg.Type.IsBool)
                        return model.MkElement("false");
                    else if (arg.Type.IsInt)
                        return model.MkIntElement(0);
                    else
                        return null;
                }
            }
            else if (arg is VCExprNAry && (arg as VCExprNAry).Op is VCExprBvOp)
            {
                // support for BV constants
                var bvc = (arg as VCExprNAry)[0] as VCExprLiteral;
                if (bvc != null)
                {
                    var ret = model.TryMkElement(bvc.ToString() + arg.Type.ToString());
                    if (ret != null && (ret is Model.BitVector)) return ret;
                }
            }
           
            var val = prover.Evaluate(arg);
            if (val is int || val is bool || val is Microsoft.Basetypes.BigNum)
            {
                return model.MkElement(val.ToString());
            }
            else
            {
                Debug.Assert(false);
            }
            return null;
        }

        // Remove functions AbsHoudiniConstant from the expressions and substitute them with "true"
        class ExistentialExprModelMassage : StandardVisitor
        {
            List<Function> ahFuncs;

            public ExistentialExprModelMassage()
            {
                ahFuncs = new List<Function>();
            }

            public static Tuple<Expr, List<Function>> Massage(Expr expr)
            {
                var ee = new ExistentialExprModelMassage();
                expr = ee.VisitExpr(expr);
                return Tuple.Create(expr, ee.ahFuncs);
            }

            public override Expr VisitNAryExpr(NAryExpr node)
            {
                if (node.Fun is FunctionCall && (node.Fun as FunctionCall).FunctionName.StartsWith("AbsHoudiniConstant"))
                {
                    ahFuncs.Add((node.Fun as FunctionCall).Func);
                    return Expr.True;
                }

                return base.VisitNAryExpr(node);
            }
        }

        class FunctionCollector : StandardVisitor
        {
            public List<Tuple<Function, ExistsExpr>> functionsUsed;
            ExistsExpr existentialExpr;

            public FunctionCollector()
            {
                functionsUsed = new List<Tuple<Function, ExistsExpr>>();
                existentialExpr = null;
            }

            public static List<Tuple<Function, ExistsExpr>> Collect(Expr expr)
            {
                var fv = new FunctionCollector();
                fv.VisitExpr(expr);
                return fv.functionsUsed;
            }

            public override QuantifierExpr VisitQuantifierExpr(QuantifierExpr node)
            {
                var oldE = existentialExpr;

                if (node is ExistsExpr)
                    existentialExpr = (node as ExistsExpr);

                node = base.VisitQuantifierExpr(node);

                existentialExpr = oldE;
                return node;
            }

            public override Expr VisitNAryExpr(NAryExpr node)
            {
                if (node.Fun is FunctionCall)
                {
                    var collector = new VariableCollector();
                    collector.Visit(node);

                    if(existentialExpr != null && existentialExpr.Dummies.Intersect(collector.usedVars).Any())
                        functionsUsed.Add(Tuple.Create((node.Fun as FunctionCall).Func, existentialExpr));
                    else
                        functionsUsed.Add(Tuple.Create<Function, ExistsExpr>((node.Fun as FunctionCall).Func, null));
                }

                return base.VisitNAryExpr(node);
            }
        }

        class P_FunctionCollector : StandardVisitor
        {
            public List<Function> functionsUsed;
            
            public P_FunctionCollector()
            {
                functionsUsed = new List<Function>();
            }

            public static List<Function> Collect(Expr expr)
            {
                var fv = new P_FunctionCollector();
                fv.VisitExpr(expr);
                return fv.functionsUsed;
            }

            public override BinderExpr VisitBinderExpr(BinderExpr node)
            {
                Debug.Assert(false);
 	            return base.VisitBinderExpr(node);
            }
                 
            public override Expr VisitNAryExpr(NAryExpr node)
            {
                if (node.Fun is FunctionCall)
                {
                    var collector = new VariableCollector();
                    collector.Visit(node);

                    functionsUsed.Add((node.Fun as FunctionCall).Func);
                }

                return base.VisitNAryExpr(node);
            }
        }

        class InstrumentedCheckHandler : ProverInterface.ErrorHandler
        {
            public override void OnModel(IList<string> labels, Model model)
            {
                base.OnModel(labels, model);
            }
        }
        
        class GeneralizeCheckCallBack : VerifierCallback
        {
            private MLHoudini container;
            private string impl;

            public GeneralizeCheckCallBack(MLHoudini container, string impl)
            {
                this.container = container;
                this.impl = impl;
            }

            public override void OnCounterexample(Counterexample ce, string reason)
            {
                container.VCisValid = false;
            }
        }

        class InstrumentedCheckCallBack : VerifierCallback
        {
            private MLHoudini container;
            private string impl;

            public InstrumentedCheckCallBack(MLHoudini container, string impl)
            {
                this.container = container;
                this.impl = impl;
            }

            public override void OnCounterexample(Counterexample ce, string reason)
            {
                container.HandleCounterExampleInstrumented(impl, ce);
            }
        }

        private void HandleCounterExampleInstrumented(string impl, Counterexample error)
        {
            // this method is called when we check an instrumented program
            // to generate positive samples.
            
            VCisValid = false;
            
            // handle the possible counterexample
            var cex = P_ExtractState(impl, error);

            // // the counter-example does not involve any existential function ==> Is a real counter-example !
            // if (cex.Item1.Count == 0 && cex.Item2.Count == 0)
            // {
            //     cexAdded = false;
            //     return true;
            // }

            if (cex.Item1.Count == 0 || cex.Item2.Count == 0)
            {
                AddCounterExample(cex);
            }
        }

        class MLHoudiniCounterexampleCollector : VerifierCallback
        {
            /*public HashSet<string> funcsChanged;            
            public int numErrors;
             */
            public string currImpl;
            public List<Counterexample> real_errors;
            public List<Counterexample> conjecture_errors;
            public List<Counterexample> implication_errors;

            MLHoudini container;

            public MLHoudiniCounterexampleCollector(MLHoudini container)
            {
                this.container = container;
                Reset(null);
            }

            public void Reset(string impl)
            {
                //funcsChanged = new HashSet<string>();
                currImpl = impl;
                //numErrors = 0;
                real_errors = new List<Counterexample>();
                conjecture_errors = new List<Counterexample>();
                implication_errors = new List<Counterexample>();
            }

            public override void OnCounterexample(Counterexample ce, string reason)
            {                
                //numErrors++;                
#if Pranav
                bool counterExampleAdded;
                if (container.HandleCounterExample(currImpl, ce, out counterExampleAdded))
                {
                    real_errors.Add(ce);
                }
                else
                {
                    if (counterExampleAdded)
                    {
                        conjecture_errors.Add(ce);
                    }
                }
#endif
                bool cexAdded;
                if (container.HandleCounterExample(currImpl, ce, out cexAdded))
                {
                    real_errors.Add(ce);
                }
                else
                {
                    if (cexAdded)
                    {
                        conjecture_errors.Add(ce);
                    }
                    else
                    {
                        implication_errors.Add(ce);
                    }
                }
                //funcsChanged.UnionWith(
                //    container.HandleCounterExample(currImpl, ce));
            }
        }

        private void GenVC(Implementation impl)
        {
            ModelViewInfo mvInfo;
            Dictionary<int, Absy> label2absy;
            var collector = new MLHoudiniCounterexampleCollector(this);
            collector.OnProgress("HdnVCGen", 0, 0, 0.0);

            if (CommandLineOptions.Clo.Trace)
            {
                Console.WriteLine("Generating VC of {0}", impl.Name);
            }

            vcgen.ConvertCFG2DAG(impl);
            var gotoCmdOrigins = vcgen.PassifyImpl(impl, out mvInfo);

            // Inline functions
            (new InlineFunctionCalls()).VisitBlockList(impl.Blocks);

            ExtractQuantifiedExprs(impl);
            StripOutermostForall(impl);

            //CommandLineOptions.Clo.PrintInstrumented = true;
            //var tt = new TokenTextWriter(Console.Out);
            //impl.Emit(tt, 0);
            //tt.Close();

            // Intercept the FunctionCalls of the existential functions, and replace them with Boolean constants
            var existentialFunctionNames = new HashSet<string>(existentialFunctions.Keys);
            HashSet<string> constantsAssumed = new HashSet<string>();
            StandardVisitor fv0;
            if (CommandLineOptions.Clo.RSInfer)
            {
                fv0 = new MLReplaceFunctionCalls(existentialFunctionNames);
                MLReplaceFunctionCalls fv = (MLReplaceFunctionCalls)fv0;
                fv.VisitBlockList(impl.Blocks);

                // this.instrumentationMapForRS = fv.instrumentMap;
                // if (instrumentationMapForRS != null) this.implWithRS = impl;
            
                impl2functionsAsserted.Add(impl.Name, ((MLReplaceFunctionCalls)fv).functionsAsserted);
                impl2functionsAssumed.Add(impl.Name, ((MLReplaceFunctionCalls)fv).functionsAssumed);

                foreach (var func in ((MLReplaceFunctionCalls)fv).functionsForRecurrentSet)
                {
                    this.functionForRecurrentSet.Add(func);
                }

                fv.functionsAssumed.Iter(f => function2implAssumed[f].Add(impl.Name));
                fv.functionsAsserted.Iter(f => function2implAsserted[f].Add(impl.Name));

                impl2FuncCalls.Add(impl.Name, fv.functionsUsed);
                fv.functionsUsed.Iter(tup => constant2FuncCall.Add(tup.Item2.Name, tup.Item3));
                
                fv.functionsUsed.Where(tup => impl2functionsAssumed[impl.Name].Contains(tup.Item1)).Iter(tup => constantsAssumed.Add(tup.Item2.Name));

            }
            else
            {
                fv0 = new ReplaceFunctionCalls(existentialFunctionNames);
                ReplaceFunctionCalls fv = (ReplaceFunctionCalls)fv0;
                fv.VisitBlockList(impl.Blocks);

                impl2functionsAsserted.Add(impl.Name, fv.functionsAsserted);
                impl2functionsAssumed.Add(impl.Name, fv.functionsAssumed);

                fv.functionsAssumed.Iter(f => function2implAssumed[f].Add(impl.Name));
                fv.functionsAsserted.Iter(f => function2implAsserted[f].Add(impl.Name));

                impl2FuncCalls.Add(impl.Name, fv.functionsUsed);
                fv.functionsUsed.Iter(tup => constant2FuncCall.Add(tup.Item2.Name, tup.Item3));

                fv.functionsUsed.Where(tup => impl2functionsAssumed[impl.Name].Contains(tup.Item1)).Iter(tup => constantsAssumed.Add(tup.Item2.Name));

            }
            
            var gen = prover.VCExprGen;
            VCExpr controlFlowVariableExpr = CommandLineOptions.Clo.UseLabels ? null : gen.Integer(Microsoft.Basetypes.BigNum.ZERO);

            var vcexpr = vcgen.P_GenerateVC(impl, constantsAssumed, controlFlowVariableExpr, out label2absy, prover.Context);
            //var vcexpr = vcgen.GenerateVC(impl, controlFlowVariableExpr, out label2absy, prover.Context);

            if (!CommandLineOptions.Clo.UseLabels)
            {
                VCExpr controlFlowFunctionAppl = gen.ControlFlowFunctionApplication(gen.Integer(Microsoft.Basetypes.BigNum.ZERO), gen.Integer(Microsoft.Basetypes.BigNum.ZERO));
                VCExpr eqExpr = gen.Eq(controlFlowFunctionAppl, gen.Integer(Microsoft.Basetypes.BigNum.FromInt(impl.Blocks[0].UniqueId)));
                vcexpr = gen.Implies(eqExpr, vcexpr);
            }

            ProverInterface.ErrorHandler handler = null;
            if (CommandLineOptions.Clo.vcVariety == CommandLineOptions.VCVariety.Local)
                handler = new VCGen.ErrorReporterLocal(gotoCmdOrigins, label2absy, impl.Blocks, vcgen.incarnationOriginMap, collector, mvInfo, prover.Context, program);
            else
                handler = new VCGen.ErrorReporter(gotoCmdOrigins, label2absy, impl.Blocks, vcgen.incarnationOriginMap, collector, mvInfo, prover.Context, program);

            impl2ErrorHandler.Add(impl.Name, Tuple.Create(handler, collector));

            //Console.WriteLine("VC of {0}: {1}", impl.Name, vcexpr);

            // Create a macro so that the VC can sit with the theorem prover
            Macro macro = new Macro(Token.NoToken, impl.Name + "Macro", new List<Variable>(), new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "", Bpl.Type.Bool), false));
            prover.DefineMacro(macro, vcexpr);

            //Console.WriteLine("Function " + impl.Name + ":\n" + vcexpr.ToString());

            // Store VC
            impl2VC.Add(impl.Name, gen.Function(macro));

            // HACK: push the definitions of constants involved in function calls
            // It is possible that some constants only appear in function calls. Thus, when
            // they are replaced by Boolean constants, it is possible that (get-value) will 
            // fail if the expression involves such constants. All we need to do is make sure
            // these constants are declared, because otherwise, semantically we are doing
            // the right thing.
            if (fv0 is MLReplaceFunctionCalls)
            {
                MLReplaceFunctionCalls fv = (MLReplaceFunctionCalls)fv0;
                foreach (var tup in fv.functionsUsed)
                {
                    // Ignore ones with bound varibles
                    if (tup.Item2.InParams.Count > 0) continue;
                    var tt = prover.Context.BoogieExprTranslator.Translate(tup.Item3);
                    tt = prover.VCExprGen.Or(VCExpressionGenerator.True, tt);
                    prover.Assert(tt, true);
                }
            }
            else
            {
                ReplaceFunctionCalls fv = (ReplaceFunctionCalls)fv0;
                foreach (var tup in fv.functionsUsed)
                {
                    // Ignore ones with bound varibles
                    if (tup.Item2.InParams.Count > 0) continue;
                    var tt = prover.Context.BoogieExprTranslator.Translate(tup.Item3);
                    tt = prover.VCExprGen.Or(VCExpressionGenerator.True, tt);
                    prover.Assert(tt, true);
                }
            }
        }

        // convert "foo(... forall e ...) to:
        //    (p iff forall e) ==> foo(... p ...) 
        // where p is a fresh boolean variable and foo is an existential constant
        private void ExtractQuantifiedExprs(Implementation impl)
        {
            var funcs = new HashSet<string>(existentialFunctions.Keys);
            foreach (var blk in impl.Blocks)
            {
                foreach (var acmd in blk.Cmds.OfType<AssertCmd>())
                {
                    var ret = ExtractQuantifiers.Extract(acmd.Expr, funcs);
                    acmd.Expr = ret.Item1;
                    impl.LocVars.AddRange(ret.Item2);
                }
            }
        }

        // convert "assert e1 && forall x: e2" to
        //    assert e1 && e2[x <- x@bound]
        private void StripOutermostForall(Implementation impl)
        {
            var funcs = new HashSet<string>(existentialFunctions.Keys);
            foreach (var blk in impl.Blocks)
            {
                foreach (var acmd in blk.Cmds.OfType<AssertCmd>())
                {
                    var ret = StripQuantifiers.Run(acmd.Expr, funcs);
                    acmd.Expr = ret.Item1;
                    impl.LocVars.AddRange(ret.Item2);
                }
            }
        }

        private void Inline()
        {
            if (CommandLineOptions.Clo.InlineDepth < 0)
                return;

            var callGraph = BuildCallGraph();

            foreach (Implementation impl in callGraph.Nodes)
            {
                InlineRequiresVisitor inlineRequiresVisitor = new InlineRequiresVisitor();
                inlineRequiresVisitor.Visit(impl);
            }

            foreach (Implementation impl in callGraph.Nodes)
            {
                FreeRequiresVisitor freeRequiresVisitor = new FreeRequiresVisitor();
                freeRequiresVisitor.Visit(impl);
            }

            foreach (Implementation impl in callGraph.Nodes)
            {
                InlineEnsuresVisitor inlineEnsuresVisitor = new InlineEnsuresVisitor();
                inlineEnsuresVisitor.Visit(impl);
            }

            foreach (Implementation impl in callGraph.Nodes)
            {
                impl.OriginalBlocks = impl.Blocks;
                impl.OriginalLocVars = impl.LocVars;
            }
            foreach (Implementation impl in callGraph.Nodes)
            {
                CommandLineOptions.Inlining savedOption = CommandLineOptions.Clo.ProcedureInlining;
                CommandLineOptions.Clo.ProcedureInlining = CommandLineOptions.Inlining.Spec;
                Inliner.ProcessImplementationForHoudini(program, impl);
                CommandLineOptions.Clo.ProcedureInlining = savedOption;
            }
            foreach (Implementation impl in callGraph.Nodes)
            {
                impl.OriginalBlocks = null;
                impl.OriginalLocVars = null;
            }

            Graph<Implementation> oldCallGraph = callGraph;
            callGraph = new Graph<Implementation>();
            foreach (Implementation impl in oldCallGraph.Nodes)
            {
                callGraph.AddSource(impl);
            }
            foreach (Tuple<Implementation, Implementation> edge in oldCallGraph.Edges)
            {
                callGraph.AddEdge(edge.Item1, edge.Item2);
            }
            int count = CommandLineOptions.Clo.InlineDepth;
            while (count > 0)
            {
                foreach (Implementation impl in oldCallGraph.Nodes)
                {
                    List<Implementation> newNodes = new List<Implementation>();
                    foreach (Implementation succ in callGraph.Successors(impl))
                    {
                        newNodes.AddRange(oldCallGraph.Successors(succ));
                    }
                    foreach (Implementation newNode in newNodes)
                    {
                        callGraph.AddEdge(impl, newNode);
                    }
                }
                count--;
            }
        }

        private Graph<Implementation> BuildCallGraph()
        {
            Graph<Implementation> callGraph = new Graph<Implementation>();
            Dictionary<Procedure, HashSet<Implementation>> procToImpls = new Dictionary<Procedure, HashSet<Implementation>>();
            foreach (Declaration decl in program.TopLevelDeclarations)
            {
                Procedure proc = decl as Procedure;
                if (proc == null) continue;
                procToImpls[proc] = new HashSet<Implementation>();
            }
            foreach (Declaration decl in program.TopLevelDeclarations)
            {
                Implementation impl = decl as Implementation;
                if (impl == null || impl.SkipVerification) continue;
                callGraph.AddSource(impl);
                procToImpls[impl.Proc].Add(impl);
            }
            foreach (Declaration decl in program.TopLevelDeclarations)
            {
                Implementation impl = decl as Implementation;
                if (impl == null || impl.SkipVerification) continue;
                foreach (Block b in impl.Blocks)
                {
                    foreach (Cmd c in b.Cmds)
                    {
                        CallCmd cc = c as CallCmd;
                        if (cc == null) continue;
                        foreach (Implementation callee in procToImpls[cc.Proc])
                        {
                            callGraph.AddEdge(impl, callee);
                        }
                    }
                }
            }
            return callGraph;
        }
    }

    class HavocUnderApproxValidator
    {
        private List<string> vars;
        public HavocUnderApproxValidator(List<IdentifierExpr> originalHavocVars)
        {
            vars = originalHavocVars.Select(x => x.Name).ToList();
        }

        public bool visit(Expr expr)
        {
            if (expr is NAryExpr)
            {
                NAryExpr nAryExpr = expr as NAryExpr;
                return visit(nAryExpr);
            }

            throw new MLHoudiniInternalError("unrecognized expression in validator");
        }

        public bool visit(NAryExpr expr)
        {
            IAppliable fun = expr.Fun;
            if (fun is BinaryOperator)
            {
                Bpl.BinaryOperator bop = (BinaryOperator) fun;
                switch (bop.Op)
                {
                    case BinaryOperator.Opcode.And:
                    case BinaryOperator.Opcode.Or:
                        // return expr.Args.TrueForAll(e => visit(e));
                        return false;
                }
            } 
            else if (fun is UnaryOperator)
            {
                UnaryOperator uop = (UnaryOperator) fun;
                switch (uop.Op)
                {
                    case UnaryOperator.Opcode.Not:
                        return expr.Args.TrueForAll(e => visit(e));
                }
            }
            VariableNameCollector collector = new VariableNameCollector();
            collector.Visit(expr);
            return check(collector.usedVars);
        }

        // check if either
        // 1) collected vars is empty
        // 2) vars is contained in collected
        private bool check(List<string> collectorUsedVars)
        {
            if (collectorUsedVars.Count == 0)
                return true;
            
            List<string> basenames = collectorUsedVars.Select(x => x.Split('@')[0]).ToList();

            foreach (string s in vars)
            {
                if (!basenames.Contains(s))
                    return false;
            }

            return true;
        }
    }

    public interface MLICEDomain
    {
        bool constructModel(string funcName, C5TreeNode root, Dictionary<string, Dictionary<string, Expr>> attr2Expr, Dictionary<string, int> functionID);  // returns whether the abstract value has changed?
        Expr Gamma(List<Expr> vars);
        //bool TypeCheck(List<Type> argTypes, out string msg);     
    }   

    public class C5Domain : MLICEDomain
    {
        List<string> vars;
        Expr model;
        private Expr generalizedModel;  // _ADD_VAR
        
        public C5Domain(List<Variable> functionFormalParams)
        {            
            // Initialize the invariant function with "true".
            vars = new List<string>();
            foreach (var v in functionFormalParams)
            {
                vars.Add(v.Name);
            }
            model = Expr.True;            
            //model = Expr.False;
            generalizedModel = Expr.True;
        }

        public Expr Gamma(List<Expr> newvars)
        {
            return ExtendsExpr.replace(model, vars, newvars);            
        }

        public Expr getModelExpr()
        {
            return model;
        }

        public List<string> getModelVars()
        {
            return vars;
        }
        
        // _ADD_FUNC
        public Expr GeneralizedGamma(List<Expr> newvars)
        {
            return ExtendsExpr.replace(generalizedModel, vars, newvars);            
        }

        /*
        public bool TypeCheck(List<Type> argTypes, out string msg)
        {
            msg = "";
            foreach(var argType in argTypes)
            {
                if (!argType.IsInt || !argType.IsBool)
                {
                    msg = "Illegal type, expecting int or bool";
                    return false;
                }
            }
            return true;
        }
        */

        // _ADD_FUNC
        public void setGeneralizedModel(Expr newModel)
        {
            generalizedModel = newModel;
        }

        public bool constructModel(string funcName, C5TreeNode root, Dictionary<string, Dictionary<string, Expr>> attr2Expr, Dictionary<string, int> functionID)
        {
            Debug.Assert(attr2Expr.Keys.Contains(funcName));
            Debug.Assert(functionID.Keys.Contains(funcName));
            return constructModel(root.children[functionID[funcName]], attr2Expr[funcName]);
        }


        public bool constructModel(C5TreeNode node, Dictionary<string, Expr> attr2Expr)
        {
            Debug.Assert(attr2Expr != null);
            Expr oldmodel = model;
            List<Expr> stack = new List<Expr>();
            stack.Add(Expr.True);
            List<List<Expr>> finalformula = node.constructBoogieExpr(stack, attr2Expr);
            if (finalformula.Count() == 0)
            {
                model = Expr.False;
                return !ExtendsExpr.EqualityComparer(model, oldmodel);
            }

            model = ExtendsExpr.disjunction(finalformula);
            if (ExtendsExpr.EqualityComparer(model, oldmodel))
            {
                //Console.WriteLine("old model: ");
                //Console.WriteLine(oldmodel.ToString());
                //Console.WriteLine("new model: ");
                //Console.WriteLine(model.ToString());                
                return false;
            }
            else
                return true;
        }
        
        /*
        public Term constructSMTConstraint(List<Model.Element> states, ref Z3Context z3Context)
        {
            Debug.Assert(states.Count == 1);
            var state = states[0] as Model.Integer;
            if (state == null)
                throw new ICEHoudiniInternalError("Incorrect type, expected int");
            var intval = state.AsInt();

            Context context = z3Context.context;

            Term termUpperLimit = context.MkConst(this.str + "_ul", z3Context.intSort);
            Term termLowerLimit = context.MkConst(this.str + "_ll", z3Context.intSort);
            Term termHasUpperLimit = context.MkConst(this.str + "_hul", z3Context.boolSort);
            Term termHasLowerLimit = context.MkConst(this.str + "_hll", z3Context.boolSort);

            Term c1_id = context.MkImplies(termHasLowerLimit, context.MkLe(termLowerLimit, context.MkNumeral(intval, z3Context.intSort)));
            Term c2_id = context.MkImplies(termHasUpperLimit, context.MkLe(context.MkNumeral(intval, z3Context.intSort), termUpperLimit));

            return context.MkAnd(c1_id, c2_id);
        }

        public bool initializeFromModel(Z3.Model model, ref Z3Context z3Context)
        {
            Debug.Assert(model != null);
            Context context = z3Context.context;

            Term termUpperLimit = context.MkConst(this.str + "_ul", z3Context.intSort);
            Term termLowerLimit = context.MkConst(this.str + "_ll", z3Context.intSort);
            Term termHasUpperLimit = context.MkConst(this.str + "_hul", z3Context.boolSort);
            Term termHasLowerLimit = context.MkConst(this.str + "_hll", z3Context.boolSort);

            bool ret = false;

            int ul = context.GetNumeralInt(model.Eval(termUpperLimit));
            int ll = context.GetNumeralInt(model.Eval(termLowerLimit));
            bool hul = context.GetBoolValue(model.Eval(termHasUpperLimit)).getBool();
            bool hll = context.GetBoolValue(model.Eval(termHasLowerLimit)).getBool();

            if((hasUpperLimit != hul) || (hasUpperLimit && hul && (upperLimit != ul)))
                ret = true;

            if ((hasLowerLimit != hll) || (hasLowerLimit && hll && (lowerLimit != ll)))
                ret = true;

            upperLimit = ul;
            lowerLimit = ll;
            hasUpperLimit = hul;
            hasLowerLimit = hll;
            return ret;
        }
        */

        /*
        public Term currLearnedInvAsTerm(ref Z3Context z3Context)
        {
            Context context = z3Context.context;
            Term termUpperLimit = context.MkConst(this.str + "_ul", z3Context.intSort);
            Term termLowerLimit = context.MkConst(this.str + "_ll", z3Context.intSort);
            Term termHasUpperLimit = context.MkConst(this.str + "_hul", z3Context.boolSort);
            Term termHasLowerLimit = context.MkConst(this.str + "_hll", z3Context.boolSort);

            List<Term> args = new List<Term>();
            args.Add(this.hasUpperLimit ? termHasUpperLimit : context.MkNot(termHasUpperLimit));
            args.Add(this.hasLowerLimit ? termHasLowerLimit : context.MkNot(termHasLowerLimit));
            args.Add(context.MkEq(termUpperLimit, context.MkNumeral(this.upperLimit, z3Context.intSort)));
            args.Add(context.MkEq(termLowerLimit, context.MkNumeral(this.lowerLimit, z3Context.intSort)));            

            return context.MkAnd(args.ToArray());
        }*/

    }

    /*
    class InlineFunctionCalls : StandardVisitor
    {
        public Stack<string> inlinedFunctionsStack;

        public InlineFunctionCalls()
        {
            inlinedFunctionsStack = new Stack<string>();
        }

        public override Expr VisitNAryExpr(NAryExpr node)
        {
            var fc = node.Fun as FunctionCall;
            if (fc != null && fc.Func.Body != null && QKeyValue.FindBoolAttribute(fc.Func.Attributes, "inline"))
            {
                if (inlinedFunctionsStack.Contains(fc.Func.Name))
                {
                    // recursion detected
                    throw new MLHoudiniInternalError("Recursion detected in function declarations");
                }

                // create a substitution
                var subst = new Dictionary<Variable, Expr>();
                for (int i = 0; i < node.Args.Count; i++)
                {
                    subst.Add(fc.Func.InParams[i], node.Args[i]);
                }

                var e =
                    Substituter.Apply(new Substitution(v => subst.ContainsKey(v) ? subst[v] : Expr.Ident(v)), fc.Func.Body);

                inlinedFunctionsStack.Push(fc.Func.Name);

                e = base.VisitExpr(e);

                inlinedFunctionsStack.Pop();

                return e;
            }
            return base.VisitNAryExpr(node);
        }
    }
     */
 
    public class MLHoudiniInternalError : System.ApplicationException
    {
        public MLHoudiniInternalError(string msg) : base(msg) { }

    };


    class InlineFunctionCalls : StandardVisitor
    {
        public Stack<string> inlinedFunctionsStack;

        public InlineFunctionCalls()
        {
            inlinedFunctionsStack = new Stack<string>();
        }

        public override Expr VisitNAryExpr(NAryExpr node)
        {
            var fc = node.Fun as FunctionCall;
            if (fc != null && fc.Func.Body != null && QKeyValue.FindBoolAttribute(fc.Func.Attributes, "inline"))
            {
                if (inlinedFunctionsStack.Contains(fc.Func.Name))
                {
                    // recursion detected
                    throw new MLHoudiniInternalError("Recursion detected in function declarations");
                }

                // create a substitution
                var subst = new Dictionary<Variable, Expr>();
                for (int i = 0; i < node.Args.Count; i++)
                {
                    subst.Add(fc.Func.InParams[i], node.Args[i]);
                }

                var e =
                    Substituter.Apply(new Substitution(v => subst.ContainsKey(v) ? subst[v] : Expr.Ident(v)), fc.Func.Body);

                inlinedFunctionsStack.Push(fc.Func.Name);

                e = base.VisitExpr(e);

                inlinedFunctionsStack.Pop();

                return e;
            }
            return base.VisitNAryExpr(node);
        }
    }
 
    
    class MLHoudiniErrorReporter : ProverInterface.ErrorHandler
    {
        public Model model;

        public MLHoudiniErrorReporter()
        {
            model = null;
        }

        public override void OnModel(IList<string> labels, Model model)
        {
            Debug.Assert(model != null);
            if(CommandLineOptions.Clo.PrintErrorModel >= 1) model.Write(Console.Out);
            this.model = model;
        }
    }

    class MLReplaceFunctionCalls : StandardVisitor
    {
        public List<Tuple<string, Function, NAryExpr>> functionsUsed;
        public List<Function> boolConstants;

        public HashSet<string> functionsAssumed;
        public HashSet<string> functionsAsserted;

        public List<string> functionsForRecurrentSet;
        HashSet<string> functionsToReplace;

        private bool inAssume;
        private bool inRSAssume;
        private bool inAssert;
        private bool inFunction;
        private List<Dictionary<string, Variable>> boundVars;
        private static int IdCounter = 0;

        // private AssumeCmd instrument1;
        // private AssertCmd instrument2;

        // public Tuple<int, Block> instrumentMap;

        private int blockcnt = -1;

        public MLReplaceFunctionCalls(HashSet<string> functionsToReplace)
        {
            this.functionsUsed = new List<Tuple<string, Function, NAryExpr>>();
            this.functionsToReplace = functionsToReplace;
            this.functionsAsserted = new HashSet<string>();
            this.functionsAssumed = new HashSet<string>();
            this.functionsForRecurrentSet = new List<string>();
            this.boolConstants = new List<Function>();
            this.boundVars = new List<Dictionary<string, Variable>>();

            inAssume = false;
            inAssert = false;
            inFunction = false;
            inRSAssume = false;
        }

        public override Cmd VisitAssertCmd(AssertCmd node)
        {
            inAssert = true;
            var ret = base.VisitAssertCmd(node);
            inAssert = false;
            return ret;
        }

        public override Cmd VisitAssertEnsuresCmd(AssertEnsuresCmd node)
        {
            return this.VisitAssertCmd(node);
        }

        public override Cmd VisitAssertRequiresCmd(AssertRequiresCmd node)
        {
            return this.VisitAssertCmd(node);
        }

        public override Block VisitBlock(Block node)
        {
            blockcnt++;
            
            Block b = base.VisitBlock(node);

            return b;
        }

        public override Cmd VisitAssumeCmd(AssumeCmd node)
        {
            inAssume = true;
            if (node is RecurrentSetAssumeCMD)
            {
                inRSAssume = true;
            }
            var ret = base.VisitAssumeCmd(node);
            inAssume = false;
            inRSAssume = false;
            return ret;
        }

        public override QuantifierExpr VisitQuantifierExpr(QuantifierExpr node)
        {
            // gather the quantified variables
            var dummies = new Dictionary<string, Variable>();
            node.Dummies.Iter(v => dummies.Add(v.Name, v));

            boundVars.Add(dummies);

            node = base.VisitQuantifierExpr(node);

            boundVars.RemoveAt(boundVars.Count - 1);

            return node;
        }

        public override Expr VisitNAryExpr(NAryExpr node)
        {
            var inF = inFunction;

            if (node.Fun is FunctionCall && functionsToReplace.Contains((node.Fun as FunctionCall).FunctionName))
            {
                found((node.Fun as FunctionCall).FunctionName);
                inFunction = true;

                // collect all the variables used by this function
                var collector = new VariableCollector();
                collector.VisitExpr(node);

                // Find the outermost bound variables
                var bound = new List<Variable>();
                if (boundVars.Count > 0)
                    bound.AddRange(collector.usedVars.Intersect(boundVars[0].Values));

                // create boolean function to replace this guy
                var constant = new Function(Token.NoToken, "MLHoudiniConstant" + IdCounter, bound,
                    new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
                IdCounter++;

                functionsUsed.Add(Tuple.Create((node.Fun as FunctionCall).FunctionName, constant, node));
                boolConstants.Add(constant);

                var args = new List<Expr>();
                bound.OfType<Variable>().Select(v => Expr.Ident(v)).Iter(v => args.Add(v));
                return new NAryExpr(Token.NoToken, new FunctionCall(constant), args);
            }
            var ret = base.VisitNAryExpr(node);

            inFunction = inF;

            return ret;
        }

        public override Expr VisitIdentifierExpr(IdentifierExpr node)
        {
            if (inFunction)
            {
                // Inside functions we can only refer to the outermost bound variables
                for (int i = boundVars.Count - 1; i >= 1; i--)
                {
                    if (boundVars[i].ContainsKey(node.Name))
                        throw new AbsHoudiniInternalError("Existential functions can only refer to outermost bound variables in an expression");
                }
            }

            return base.VisitIdentifierExpr(node);
        }

        private void found(string func)
        {
            if (inAssume) functionsAssumed.Add(func);
            if (inAssert) functionsAsserted.Add(func);
            if (inRSAssume) functionsForRecurrentSet.Add(func);
        }
    }

    class HavocInstrumenter : StandardVisitor
    {
        private List<Cmd> workingCmdSeq;
        public Dictionary<string, HavocCmd> func2Cmds;
        public List<Function> constants;

        private int IdCounter = 0;

        public HavocInstrumenter()
        {
            func2Cmds = new Dictionary<string, HavocCmd>();
            constants = new List<Function>();
        }
        
        public override Cmd VisitHavocCmd(HavocCmd node)
        {
            Cmd ret = base.VisitHavocCmd(node);
            workingCmdSeq.Add(ret);
            
            var constant = new Function(Token.NoToken, "HavocApprox" + IdCounter, new List<Variable>(),
                new Formal(Token.NoToken, new TypedIdent(Token.NoToken, "r", Microsoft.Boogie.Type.Bool), false));
            IdCounter++;

            constants.Add(constant);

            var args = new List<Expr>();
            var exp = new NAryExpr(Token.NoToken, new FunctionCall(constant), args);
            var approxCmd = new NondetApproxAssumeCmd(node.tok, exp);
            
            func2Cmds.Add(constant.Name, node);
            
            return approxCmd;
        }

        public override List<Cmd> VisitCmdSeq(List<Cmd> cmdSeq) {
          Contract.Requires(cmdSeq != null);
          Contract.Ensures(Contract.Result<List<Cmd>>() != null);

          workingCmdSeq = new List<Cmd>();
          lock (cmdSeq)
          {
              for (int i = 0, n = cmdSeq.Count; i < n; i++)
              {
                  workingCmdSeq.Add((Cmd)this.Visit(cce.NonNull(cmdSeq[i]))); // call general Visit so subtypes of Cmd get visited by their particular visitor
              }
          }
          return workingCmdSeq;
        }
    }

}
