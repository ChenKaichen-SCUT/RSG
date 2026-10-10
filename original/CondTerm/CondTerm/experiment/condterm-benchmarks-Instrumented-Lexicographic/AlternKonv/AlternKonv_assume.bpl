function {:existential true} b0(t : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
  var t, i: int;
  havoc t;

  %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;

  assume (((t <= -16) || (t > -15)) && ((t <= -14) || (t > -13)) && ((t <= -12) || (t > -11)) && ((t <= -10) || (t > -9)) && ((t <= -8) || (t > -7)) && ((t <= -6) || (t > -5)) && ((t <= -4) || (t > -3)) && ((t <= -2) || (t > -1)) && ((t <= 0) || (t > 1)) && ((t <= 2) || (t > 3)) && ((t <= 4) || (t > 5)) && ((t <= 6) || (t > 7)) && ((t <= 8) || (t > 9)) && ((t <= 10) || (t > 11)) && ((t <= 12) || (t > 13)) && ((t <= 14) || (t > 15)) && ((t <= 16) || (t > 17))); // CondTerm
  while (t != 0)
    invariant b0(t %IC%, TR1, TR2, TR3, TR4);
    rec b1(t)
  {
    %BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
	TR4 := 0;
    if (t < 0) {
      TR1 := 1;
        t := t + 2;
           if (t < 0) {
            TR2 := 1;
        t := t * (-1);
           }
    } else {
      TR3 := 1;
        t := t - 2;
        if (t > 0) {
          TR4 := 1;
            t := t * (-1);
        }
    }

    %IT%
  }

  return;
}
