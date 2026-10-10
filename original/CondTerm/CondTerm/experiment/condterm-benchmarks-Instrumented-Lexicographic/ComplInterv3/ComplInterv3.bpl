function {:existential true} b0(t : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
  var t %VD%, TR1, TR2, TR3, TR4: int;
  havoc t;

  %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;

  while (t != 0)
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
        t := t + 1;
    } else {
      TR2 := 1;
        if (t < -5) {
          TR3 := 1;
            t := t - 1;
        } else {
          TR4 := 1;
            t := 0;
        }
    }

    %IT%
  }

  return;
}
