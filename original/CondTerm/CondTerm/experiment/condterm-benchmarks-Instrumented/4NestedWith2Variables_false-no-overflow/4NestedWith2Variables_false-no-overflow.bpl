function {:existential true} b0(a:int, b:int, olda:int, i:int %Decl:i% ): bool;
function {:existential true} b1(a:int, b:int, olda:int): bool;

procedure main()
{
  var a,b,olda,i: int;
  havoc a;
  havoc b;

  assume(%M:i%);
  	
  while (a > 0)
  invariant b0(a,b,olda,i %Inv:i%);
  rec b1(a,b,olda)
  {
    %assert(i > 0);%
    olda := a;
    a := 3*olda - 4*b;
    b := 4*olda + 3*b;
    %i := i - 1;%
  }
}
