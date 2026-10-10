function {:existential true} b0(x:int, y:int, z:int %FD%): bool;
function {:existential true} b1(x:int, y:int, z:int): bool;

procedure main()
{
  var x,y,z,oldx %VD%: int;
  havoc x;
  havoc y;
  havoc z;
  
  %BE%
  	
  while (x >= 0 || y >= 0 || z >= 0)
  invariant b0(x,y,z %IC%);
  rec b1(x,y,z)
  {
    %BT%
    oldx := x;
    x := y - 1;
    y := z - 1;
    z := oldx - 1;

    %IT%
  }
}
