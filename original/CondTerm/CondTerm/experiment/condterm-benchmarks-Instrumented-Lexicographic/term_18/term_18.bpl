function {:existential true} b0(x:int, y:int, z:int %FD%, ATTM$y_MOD_50:int, ATTM$z_MOD_50:int): bool;
function {:existential true} b1(x:int, y:int, z:int): bool;

procedure main()
{
  var x,y,z %VD%: int;
  x := 0;
  y := 0;
  z := 0;

  %BE%

  while (x <= 97)
  invariant b0(x,y,z %IC%, y mod 50, z mod 50);
  rec b1(x,y,z)
  {
    %BT%
    x := y mod 50 + z mod 50;
    y := y + 1;
    z := z + 1;
    %IT%
  }
}
