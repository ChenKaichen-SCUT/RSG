// Opt-in actual algorithm integration, compiled in a separate build.
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Microsoft.Boogie;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
namespace Microsoft.Boogie.Houdini {
 public partial class MLHoudini {
  private Expr S2Integrated(Expr official,string dir,Dictionary<string,object> rec) {
   string method=Environment.GetEnvironmentVariable("RSG_STAGE2_METHOD");
   if(String.IsNullOrEmpty(method) || method=="official") return official;
   var watch=Stopwatch.StartNew();Expr result=official;
   try {
    var start=new ProcessStartInfo(Environment.GetEnvironmentVariable("RSG_STAGE2_PYTHON"));
    start.Arguments="\""+Environment.GetEnvironmentVariable("RSG_STAGE2_INTEGRATOR")+"\" \""+dir+"\" "+method;
    start.UseShellExecute=false;
    using(var process=Process.Start(start)) {
     if(!process.WaitForExit(30000)) {process.Kill();throw new TimeoutException("Integrated algorithm exceeded 30s outer watchdog");}
     if(process.ExitCode!=0) throw new Exception("Integrated process exit "+process.ExitCode);
    }
    var answer=JObject.Parse(File.ReadAllText(Path.Combine(dir,"integration.json")));
    if((bool)answer["accepted_extension"]) {
     var vars=existentialFunctions["b1"].InParams.ToDictionary(v=>v.Name,v=>v);
     result=S2ReadAst(answer["returned_ast"],vars);
     Console.WriteLine("[INFO] Generalized RS: "+result);
    }
    rec["integration_status"]=(string)answer["status"];
    rec["accepted_extension"]=(bool)answer["accepted_extension"];
   } catch(Exception e) {rec["integration_error"]=e.ToString();rec["accepted_extension"]=false;}
   watch.Stop();rec["integration_wall_seconds"]=watch.Elapsed.TotalSeconds;
   rec["official_rsg_seconds"]=rec["rsg_seconds"];
   rec["rsg_seconds"]=(double)rec["rsg_seconds"]+watch.Elapsed.TotalSeconds;
   rec["returned_ast"]=S2Ast(result);rec["returned_boogie"]=result.ToString();
   File.WriteAllText(Path.Combine(dir,"trace.json"),JsonConvert.SerializeObject(rec,Formatting.Indented));
   return result;
  }
 }
}
