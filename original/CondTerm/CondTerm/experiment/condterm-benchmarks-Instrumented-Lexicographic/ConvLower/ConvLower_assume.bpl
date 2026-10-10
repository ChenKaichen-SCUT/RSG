function {:existential true} b0(t : int %FD%, TR1:int): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
  var t %VD%, TR1: int;
  havoc t;

  %BE%
  TR1 := 0;

  assume (t <= 9); // CondTerm
  while (t > 5)
    invariant b0(t %IC%, TR1);
    rec b1(t)
  {
    %BT%
	TR1 := 0;
    if (t != 10) {
      TR1 := 1;
        t := t - 1;
    }

    %IT%
  }

  return;
}
