function {:existential true} b0(t : int, w : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int): bool;
function {:existential true} b1(t : int, w : int): bool;

procedure main()
{
  var t: int;
  var w, i : int;
  havoc t;
  w := 5;

  %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;

  assume ((w <= 4) || ((t <= w) && (t + w > -1))); // CondTerm
  while (t != 0)
    invariant b0(t, w %IC%, TR1, TR2, TR3, TR4);
    rec b1(t, w)
  {
    %BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
	TR4 := 0;
    if (t < -1 * w) {
      TR1 := 1;
        t := t - 1;
        t := t * (-1);
    } else {
      TR2 := 1;
        if (t > w) {
          TR3 := 1;
            t := t + 1;
            t := t * (-1);
        } else {
          TR4 := 1;
            t := 0;
        }
    }
    w := w + 1;

    %IT%
  }

  return;
}
