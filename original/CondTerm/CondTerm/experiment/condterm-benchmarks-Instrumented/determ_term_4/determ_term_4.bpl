function {:existential true} b0(x:int, y:int, z:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int, z:int): bool;

procedure main()
{
  var x,y,z,i: int;
  x := 4;
  y := -5;
  z := 1;
  
  assume(%M:i%);
  	
  while (x + y != z)
  invariant b0(x,y,z,i %Inv:i%);
  rec b1(x,y,z)
  {
    %assert(i > 0);%
    x := x * -3;
    y := y + 2;
    z := z - 36;

    %i := i - 1;%
  }
}
