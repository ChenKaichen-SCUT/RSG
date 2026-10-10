function {:existential true} b0(x:int, y:int, z:int %FD%): bool;
function {:existential true} b1(x:int, y:int, z:int): bool;

procedure main()
{
  var x,y,z %VD%: int;

  havoc x;
  y := 100;
  z := 1;

  %BE%
  	
  while (x >= 0)
  invariant b0(x,y,z %IC%);
  rec b1(x,y,z)
  {
    %BT%
    x := x - y;
    y := y - z;
    z := -z;
    
    %IT%
  }
}
