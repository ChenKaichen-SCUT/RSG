function {:existential true} b0(p:int,x:int %FD%):bool;
function {:existential true} b1(p:int,x:int):bool;
procedure main() {
 var p,x %VD%:int;
 havoc p,x;
 %BE%
 while ((p == 0 && 0 <= x && x <= 2) || (p == 1 && 3 <= x && x <= 4))
 invariant b0(p,x %IC%);
 rec b1(p,x)
 {
 %BT%
 x:=4-x;
 p:=1-p;
 %IT%
 }
 return;
}
