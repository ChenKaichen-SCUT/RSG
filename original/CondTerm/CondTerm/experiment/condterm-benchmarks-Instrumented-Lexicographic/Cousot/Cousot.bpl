function {:existential true} b0(t : int, j : int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
  var t: int;
  var j %VD%, TR1, TR2: int;
  havoc t;
  havoc j;

  %BE%
  TR1 := 0;
  TR2 := 0;

  while (true)
    invariant b0(t, j %IC%, TR1, TR2);
    rec b1(t, j)
  {
    %BT%
	TR1 := 0;
	TR2 := 0;
    if (t < j) {
      TR1 := 1;
        t := t + 4;
    } else {
      TR2 := 1;
        j := j + 1;
        t := t + 2;
    }

    %IT%
  }

  return;
}
