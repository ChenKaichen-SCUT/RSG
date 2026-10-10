#!/usr/bin/env python3
import argparse,json,pathlib,sys,traceback
sys.path.insert(0,str(pathlib.Path(__file__).resolve().parents[1]/'src'))
import z3
from common import ROOT,S,dump
from semantics import Context

def validate(path):
 key=str(path.parent.relative_to(S/'corpus'));out={'instance':key}
 try:
  c=Context(path.parent,log=S/'logs/validation'/key)
  out.update(status='validated',variables=c.trace['variables'],dnf_terms=len(c.terms),atoms=sum(len(t) for t in c.trace['dnf']),
      seed=c.validate(c.seed,'input'),official=c.validate(c.official,'official'),official_comparison=c.compare(c.seed,c.official,'seed_official'),
      polarity_supported=c.supports_polarity)
  nonempty,_=c.check('seed_nonempty',c.seed,'sat');out['seed_nonempty']=nonempty
  # Check reduction of definitional auxiliaries agrees for the actual seed.
  original=c.apply_candidate(c.raw_bad,c.seed)
  raw,_=c.check('raw_seed_valid',original,'unsat');out['raw_seed']=raw
  out['control_elimination']=c.check('elimination_equivalence',z3.Xor(z3.Exists(c.control_variables,c.raw_bad),c.bad),'unsat')[0]
  if c.supports_polarity:
   out['polarity_equivalence']=c.check('polarity_same_candidate',z3.Xor(c.polarized(c.seed,c.seed),c.instance(c.seed)),'unsat')[0]
  out['queries']=c.queries
  if not all([out['seed']['valid'],out['official']['valid'],nonempty['passed'],raw['passed'],out['control_elimination']['passed'],out.get('polarity_equivalence',{'passed':True})['passed']]):out['status']='validation_failed'
 except Exception as e:out.update(status='unsupported',error=str(e),traceback=traceback.format_exc())
 dump(S/'results/validation'/path.parent.relative_to(S/'corpus')/'validation.json',out)
 print(key,out['status'],out.get('dnf_terms'),flush=True);return out
if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('--label',default='primary');args=ap.parse_args()
 for path in sorted((S/'corpus'/args.label).glob('*/call_*/trace.json')):validate(path)
