function {:existential true} b0(x:int, y:int, z:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int, z:int): bool;

procedure main()
{
  var x,y,z,i: int;
  x := 0;
  y := 0;
  z := 0;

  assume(%M:i%);

  while (x < 100)
  invariant b0(x,y,z,i %Inv:i%);
  rec b1(x,y,z)
  {
    %assert(i > 0);%
    x := x + y;
    y := z + 1;
    z := y - 1;
    %i := i - 1;%
  }
}
