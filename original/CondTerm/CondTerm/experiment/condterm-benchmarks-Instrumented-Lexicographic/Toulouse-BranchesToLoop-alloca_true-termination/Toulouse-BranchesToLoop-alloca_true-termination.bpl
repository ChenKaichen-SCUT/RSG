function {:existential true} b0(x:int, y:int, z:int %FD%): bool;
function {:existential true} b1(y:int, z:int, x:int): bool;

procedure main()
{
  var x,y,z %VD%: int;
  havoc x;
  havoc y;
  havoc z;

  if (*) {
    x := 1;
  } else {
    x := -1;
  }

  %BE%

  while (y < 100 && z < 100)
  invariant b0(x,y,z %IC%);
  rec b1(y,z,x)
  {
    %BT%
    y := y + x;
    z := z - x;
    %IT%
  }
}
