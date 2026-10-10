function {:existential true} b0(x:int, y:int, z:int %FD%): bool;
function {:existential true} b1(x:int, y:int, z:int): bool;

procedure main()
{
  var x,y,z %VD%: int;
  x := 0;
  y := 0;
  z := 0;

  %BE%

  while (x < 100)
  invariant b0(x,y,z %IC%);
  rec b1(x,y,z)
  {
    %BT%
    x := x + y;
    y := z + 1;
    z := y - 1;
    %IT%
  }
}
