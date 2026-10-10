function {:existential true} b0(x:int, y:int, z:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int, z:int): bool;

procedure main()
{
  var x,y,z,oldx,i: int;
  x := 8;
  y := 9;
  z := -2;
  
  assume(%M:i%);
  	
  while (x + y + z != 0)
  invariant b0(x,y,z,i %Inv:i%);
  rec b1(x,y,z)
  {
    %assert(i > 0);%
    oldx := x;
    x := -y + 1;
    y := 2 * oldx + z;
    z := z * 3;

    %i := i - 1;%
  }
}
