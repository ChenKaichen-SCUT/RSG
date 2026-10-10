#!/usr/bin/env python3
"""Separate opt-in build; leaves the frozen collection binary untouched."""
import hashlib,pathlib,shutil,sys
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
from common import S,run,dump
dst=S/'work/integrated';shutil.copytree(S/'work/traced',dst,dirs_exist_ok=True)
source=dst/'ice/popl16_artifact/Boogie/Source'
p=source/'Houdini/Stage2Trace.cs';text=p.read_text()
needle='Console.WriteLine("[STAGE2_TRACE] "+Path.Combine(dir,"trace.json"));\n   return output;'
assert needle in text;text=text.replace(needle,'Console.WriteLine("[STAGE2_TRACE] "+Path.Combine(dir,"trace.json"));\n   return S2Integrated(output,dir,rec);',1);p.write_text(text)
shutil.copy2(S/'src/Stage2Integration.cs',source/'Houdini/Stage2Integration.cs')
p=source/'Houdini/Houdini.csproj';text=p.read_text().replace('<Compile Include="Stage2Trace.cs" />','<Compile Include="Stage2Trace.cs" />\n    <Compile Include="Stage2Integration.cs" />');p.write_text(text)
r=run('integration/build',['xbuild','/p:Configuration=Release','/p:LangVersion=Experimental','NewBoogie.sln'],cwd=source,timeout=300)
dump(S/'results/integration_build.json',r)
if r['exit_code']:raise SystemExit('Integration build failed: '+r['stdout'])
print('Separate integration build complete.')
