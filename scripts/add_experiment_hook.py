#!/usr/bin/env python3
"""Add an opt-in entry without changing the body of any RSG algorithm method."""
import difflib,hashlib,json,pathlib,shutil
ROOT=pathlib.Path(__file__).resolve().parents[1]
SOURCE=ROOT/'work/CondTerm/ice/popl16_artifact/Boogie/Source'
PRISTINE=ROOT/'original/CondTerm/CondTerm/ice/popl16_artifact/Boogie/Source'

def read(p):return p.read_bytes().decode('utf-8-sig').replace('\r\n','\n')
def main():
    path=SOURCE/'Houdini/MLHoudini.cs';old=read(PRISTINE/'Houdini/MLHoudini.cs')
    start=old.index('        private Expr modifiedGeneralizeRS_2(')
    end=old.index('        private Expr modifiedGeneralizeRS(',start)
    algorithm=old[start:end]
    new=old.replace('public class MLHoudini\n','public partial class MLHoudini\n',1)
    needle='public VCGenOutcome ComputeSummaries()\n        {'
    assert needle in new
    new=new.replace(needle,needle+'\n            if (RsgExperimentRequested()) return RunRsgExperiment();',1)
    needle='Expr modelExpr = rs.getModelExpr();\n                Console.WriteLine("[INFO] Current RS: " + modelExpr);'
    assert needle in new
    new=new.replace(needle,'Expr modelExpr = rs.getModelExpr();\n                Console.WriteLine("[RSG_NATURAL_SEED_SMT] " + RsgSmt(modelExpr));\n                Console.WriteLine("[INFO] Current RS: " + modelExpr);',1)
    assert algorithm in new
    path.write_text(new)
    proj=SOURCE/'Houdini/Houdini.csproj';s=read(PRISTINE/'Houdini/Houdini.csproj')
    s=s.replace('<Compile Include="MLHoudini.cs">','<Compile Include="RSGExperiment.cs" />\n    <Compile Include="MLHoudini.cs">')
    assert 'RSGExperiment.cs' in s;proj.write_text(s)
    shutil.copyfile(ROOT/'experiments/RSGExperiment.cs',SOURCE/'Houdini/RSGExperiment.cs')
    prover=SOURCE/'Provers/SMTLib/ProverInterface.cs';s=read(PRISTINE/'Provers/SMTLib/ProverInterface.cs')
    needle='public override List<string> CheckAndUnsatCore(List<string> constants)\n    {'
    assert needle in s
    s=s.replace(needle,needle+'\n        var rsgWatch = Stopwatch.StartNew();\n        try {',1)
    needle='return unsatCore;\n    }\n    \n    public List<string> UnsatCore()'
    assert needle in s
    s=s.replace(needle,'return unsatCore;\n        } finally {\n            rsgWatch.Stop();\n            if (Environment.GetEnvironmentVariable("RSG_PROFILE") == "1")\n                Console.WriteLine("[RSG_SOLVER_SECONDS] " + rsgWatch.Elapsed.TotalSeconds.ToString("R", System.Globalization.CultureInfo.InvariantCulture));\n        }\n    }\n    \n    public List<string> UnsatCore()',1)
    prover.write_text(s)
    # Full logical source diff, normalized only for CRLF/UTF-8 BOM readability.
    diff=[]
    for rel in ('Houdini/MLHoudini.cs','Houdini/Houdini.csproj','Provers/SMTLib/ProverInterface.cs','Houdini/RSGExperiment.cs'):
        old_path=PRISTINE/rel
        before=read(old_path) if old_path.exists() else ''
        after=read(SOURCE/rel)
        diff.extend(difflib.unified_diff(before.splitlines(keepends=True),after.splitlines(keepends=True),
                    fromfile='a/'+rel if old_path.exists() else '/dev/null',tofile='b/'+rel))
    (ROOT/'patches').mkdir(exist_ok=True)
    (ROOT/'patches/rsg_experiment.patch').write_text(''.join(diff))
    result={'official_method':'MLHoudini.modifiedGeneralizeRS_2','body_unchanged':True,
            'normalized_utf8_method_sha256':hashlib.sha256(algorithm.encode()).hexdigest(),
            'entry':'opt-in ComputeSummaries branch after official constructor/VC generation',
            'telemetry':'CheckAndUnsatCore stopwatch only; no solver options changed'}
    (ROOT/'results/hook_integrity.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))

if __name__=='__main__':main()
