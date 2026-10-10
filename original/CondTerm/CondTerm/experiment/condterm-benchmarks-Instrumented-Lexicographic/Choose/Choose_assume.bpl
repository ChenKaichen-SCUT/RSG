function {:existential true} b0(t : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
  var t, i: int;
  t := 3;

  %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;

  assume (t <= 2); // CondTerm
  while (t >= 3)
    invariant b0(t %IC%, TR1, TR2, TR3, TR4);
    rec b1(t)
  {
    %BT%
    TR1 := 0;
    TR2 := 0;
    TR3 := 0;
    TR4 := 0;

    if (t > 5) {
      TR1 := 1;
        t := t + 3;
    } else {
        TR2 := 1;
        if (t > 10) {
            TR3 := 1;
            t := t - 2;
        } else {
          TR4 := 1;
            t := t + 1;
        }
    }

    %IT%
  }

  return;
}
