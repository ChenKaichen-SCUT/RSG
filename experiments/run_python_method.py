#!/usr/bin/env python3
import json,pathlib,sys
from joint import joint_two_selector,finite_region_closure_repair,exhaustive_single_term
from verify import Checker,ROOT
method=sys.argv[1];label=sys.argv[2]
functions={'joint':joint_two_selector,'repair':finite_region_closure_repair,'A4':exhaustive_single_term}
c=Checker() # Performance includes all construction and checks, but no query file I/O.
r,metrics=functions[method](c)
metrics['formula_smt2']=r.sexpr()
metrics['queries']=c.queries
(ROOT/'results/runs').mkdir(exist_ok=True)
(ROOT/'results/runs'/f'{label}.json').write_text(json.dumps(metrics,indent=2)+'\n')
print(json.dumps(metrics,indent=2))
