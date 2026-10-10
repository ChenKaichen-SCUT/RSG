function {:existential true} b0(x:int, y:int, z:int %FD%): bool;
function {:existential true} b1(x:int, z:int, y:int): bool;

procedure main()
{
  var x,y,z %VD%: int;

  havoc x;
  havoc y;
  havoc z;
  
  assume(2*y >= z);
  %BE%
  	
  while (x >= 0 && z == 1)
  invariant b0(x,y,z %IC%);
  rec b1(x,z,y)
  {
    %BT%
    x := x - 2 * y + 1;

    %IT%
  }
}
