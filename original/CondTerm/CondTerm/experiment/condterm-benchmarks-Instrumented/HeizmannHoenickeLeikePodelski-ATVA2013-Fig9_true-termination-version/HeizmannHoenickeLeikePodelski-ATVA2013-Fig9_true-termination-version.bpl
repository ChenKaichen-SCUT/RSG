function {:existential true} b0(x:int, y:int, z:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int, z:int): bool;

procedure main()
{
  var x,y,z,i: int;

  havoc x;
  havoc y;
  havoc z;
  
  assume(10 * y > z && z < 10);
  assume(%M:i%);
  	
  while (x >= 0)
  invariant b0(x,y,z,i %Inv:i%);
  rec b1(x,y,z)
  {
    %assert(i > 0);%
    x := x - 10 * y + z;

    %i := i - 1;%
  }
}
