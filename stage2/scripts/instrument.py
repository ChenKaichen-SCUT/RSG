#!/usr/bin/env python3
import difflib,hashlib,json,pathlib,shutil,sys
ROOT=pathlib.Path(__file__).resolve().parents[2];S=ROOT/'stage2'
BASE=pathlib.Path(sys.argv[1]);DEST=pathlib.Path(sys.argv[2])
rel='ice/popl16_artifact/Boogie/Source'
a=BASE/rel;b=DEST/rel
read=lambda p:p.read_text(encoding='utf-8-sig')
old=read(a/'Houdini/MLHoudini.cs');new=old.replace('public class MLHoudini\n','public partial class MLHoudini\n',1)
new=new.replace('modelExpr = modifiedGeneralizeRS_2(modelExpr);','modelExpr = S2Run(modelExpr);',1)
needle='public VCGenOutcome ComputeSummaries()\n        {'
new=new.replace(needle,needle+'\n            if (Environment.GetEnvironmentVariable("RSG_STAGE2_REPLAY") == "1") return S2Replay();',1)
start=old.index('        private Expr modifiedGeneralizeRS_2(');end=old.index('        private Expr modifiedGeneralizeRS(',start)
assert old[start:end] in new
(b/'Houdini/MLHoudini.cs').write_text(new)
proj=read(a/'Houdini/Houdini.csproj').replace('<Compile Include="MLHoudini.cs">','<Compile Include="Stage2Trace.cs" />\n    <Compile Include="MLHoudini.cs">')
(b/'Houdini/Houdini.csproj').write_text(proj)
shutil.copy2(S/'src/Stage2Trace.cs',b/'Houdini/Stage2Trace.cs')
p=read(a/'Provers/SMTLib/ProverInterface.cs')
p=p.replace('private readonly SMTLibProverContext ctx;', '''public bool Stage2CaptureOnly = false;
    public int Stage2Checks = 0, Stage2Cores = 0;
    public double Stage2Seconds = 0;
    public void Stage2Mark(string s) { if(currentLogFile!=null) { currentLogFile.WriteLine("; STAGE2_"+s); currentLogFile.Flush(); } }
    private readonly SMTLibProverContext ctx;''',1)
p=p.replace('if (Process != null)\n        Process.Send(s);','if (Process != null && !Stage2CaptureOnly)\n        Process.Send(s);',1)
p=p.replace('public override List<string> CheckAndUnsatCore(List<string> constants)\n    {','public override List<string> CheckAndUnsatCore(List<string> constants)\n    {\n        Stage2Checks++; var stage2Watch = Stopwatch.StartNew(); try {',1)
p=p.replace('return unsatCore;\n    }\n    \n    public List<string> UnsatCore()','return unsatCore;\n        } finally { stage2Watch.Stop(); Stage2Seconds += stage2Watch.Elapsed.TotalSeconds; }\n    }\n    \n    public List<string> UnsatCore()',1)
p=p.replace('SendThisVC("(get-unsat-core)");','Stage2Cores++; SendThisVC("(get-unsat-core)");',1)
(b/'Provers/SMTLib/ProverInterface.cs').write_text(p)
# Trace-specific environment and exact input snapshot; no sampling/random calls.
p=read(BASE/'src/RSLearner/RSLearner.py');needle='        process = subprocess.Popen(command,\n                                   stdout=subprocess.PIPE,\n                                   stderr=subprocess.PIPE)'
assert needle in p
p=p.replace(needle,'''        stage2_env = None
        stage2_root = os.environ.get('RSG_STAGE2_ROOT')
        if stage2_root:
            import json
            serial_file = os.path.join(stage2_root, 'next_call.txt')
            serial = int(open(serial_file).read()) if os.path.exists(serial_file) else 0
            with open(serial_file,'w') as f: f.write(str(serial+1))
            stage2_dir = os.path.join(stage2_root, 'call_%03d' % serial)
            os.makedirs(stage2_dir, exist_ok=True)
            shutil.copy2(self.fileName, os.path.join(stage2_dir,'input.bpl'))
            stage2_env = dict(os.environ, RSG_STAGE2_DIR=stage2_dir)
            command.append('/proverLog:'+os.path.join(stage2_dir,'prover.smt2'))
            with open(os.path.join(stage2_dir,'invocation.json'),'w') as f:
                json.dump({'serial':serial,'data_sharing':self.DS,'command':command,
                           'outer_iteration':os.environ.get('RSG_STAGE2_ITERATION'),
                           'program':os.environ.get('RSG_STAGE2_PROGRAM'),
                           'seed':os.environ.get('RSG_STAGE2_SEED')},f,indent=2)
        process = subprocess.Popen(command,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE,env=stage2_env)''',1)
p=p.replace('            stdoutLines.append(line)',"            stdoutLines.append(line)\n            if stage2_root:\n                with open(os.path.join(stage2_dir,'native.stdout'),'a') as f: f.write(line+'\\n')",1)
p=p.replace('        resultLine = stdoutLines[-1]',"        if stage2_root:\n            with open(os.path.join(stage2_dir,'native.stderr'),'w') as f: f.write(process.stderr.read().decode())\n        resultLine = stdoutLines[-1]",1)
(DEST/'src/RSLearner/RSLearner.py').write_text(p)
p=read(BASE/'experiment/scripts/CondTerm.py');p=p.replace('    iteration += 1','    iteration += 1\n    if os.environ.get("RSG_STAGE2_ROOT"): os.environ["RSG_STAGE2_ITERATION"] = str(iteration)',1)
(DEST/'experiment/scripts/CondTerm.py').write_text(p)
diffs=[]
for r in [rel+'/Houdini/MLHoudini.cs',rel+'/Houdini/Houdini.csproj',rel+'/Houdini/Stage2Trace.cs',rel+'/Provers/SMTLib/ProverInterface.cs','src/RSLearner/RSLearner.py','experiment/scripts/CondTerm.py']:
 prior=read(BASE/r) if (BASE/r).exists() else ''
 diffs.extend(difflib.unified_diff(prior.splitlines(True),read(DEST/r).splitlines(True),fromfile='a/'+r if prior else '/dev/null',tofile='b/'+r))
(S/'patches/tracing.patch').write_text(''.join(diffs))
(S/'results/instrumentation_integrity.json').write_text(json.dumps({'rsg_body_unchanged':True,'sha256':hashlib.sha256(old[start:end].encode()).hexdigest(),'extra_solver_queries':0,'context_export':'log-only transaction with Process.Send suppressed'},indent=2)+'\n')
print('Instrumented observation and replay, RSG method unchanged.')
