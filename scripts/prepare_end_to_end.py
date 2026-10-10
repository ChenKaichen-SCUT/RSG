#!/usr/bin/env python3
"""Equivalent official C tracing and Boogie template interfaces, arbitrary inputs."""
import pathlib,shutil
ROOT=pathlib.Path(__file__).resolve().parents[1]
G='((p == 0 && 0 <= x && x <= 2) || (p == 1 && 3 <= x && x <= 4))'
for kind in ['le','nle']:
    d=ROOT/'experiments/benchmarks'/kind/'Witness';d.mkdir(parents=True,exist_ok=True)
    header='[Testing] <Interface V3.0TR> (Basic lexical method)' if kind=='le' else '[Testing] <Interface V4.0> (Log all variables for reuse)'
    trace='%d,%d' if kind=='le' else 'p:%d,x:%d'
    c='#include <stdio.h>\nint main() {\n int p,x;\n if(scanf("%d%d", &p,&x)!=2) return 1;\n'
    c+=f' printf("{header}\\n");\n while {G} {{\n printf("{trace}\\n",p,x);\n x=4-x;\n p=1-p;\n }}\n return 0;\n}}\n'
    (d/'Witness.c').write_text(c)
    if kind=='le':
        b='function {:existential true} b0(p:int,x:int %FD%):bool;\nfunction {:existential true} b1(p:int,x:int):bool;\nprocedure main() {\n var p,x %VD%:int;\n havoc p,x;\n %BE%\n'
        b+=f' while {G}\n invariant b0(p,x %IC%);\n rec b1(p,x)\n {{\n %BT%\n x:=4-x;\n p:=1-p;\n %IT%\n }}\n return;\n}}\n'
    else:
        b='function {:existential true} b0(p:int,x:int,i:int %Decl:i%):bool;\nfunction {:existential true} b1(p:int,x:int):bool;\nprocedure main() {\n var p,x,i:int;\n havoc p,x;\n assume(%M:i%);\n'
        b+=f' while {G}\n invariant b0(p,x,i %Inv:i%);\n rec b1(p,x)\n {{\n %assert(i > 0);%\n x:=4-x;\n p:=1-p;\n %i := i - 1;%\n }}\n return;\n}}\n'
    (d/'Witness.bpl').write_text(b)
config=ROOT/'original/CondTerm/CondTerm/experiment/scripts/Config.xml'
s=config.read_text();s=s.replace('<Tmp>/tmpfs</Tmp>',f'<Tmp>{ROOT}/work/e2e</Tmp>').replace('<Log_Dir>/log</Log_Dir>',f'<Log_Dir>{ROOT}/logs/e2e</Log_Dir>')
(ROOT/'experiments/Config.xml').write_text(s)
(ROOT/'work/e2e').mkdir(parents=True,exist_ok=True)
(ROOT/'logs/e2e').mkdir(parents=True,exist_ok=True)
print('Prepared equivalent C/Boogie interfaces and official configuration with local paths.')
