function {:existential true} b0(p:int,x:int,i:int %Decl:i%):bool;
function {:existential true} b1(p:int,x:int):bool;
procedure main() {
 var p,x,i:int;
 havoc p,x;
 assume(%M:i%);
 while ((p == 0 && 0 <= x && x <= 2) || (p == 1 && 3 <= x && x <= 4))
 invariant b0(p,x,i %Inv:i%);
 rec b1(p,x)
 {
 %assert(i > 0);%
 x:=4-x;
 p:=1-p;
 %i := i - 1;%
 }
 return;
}
