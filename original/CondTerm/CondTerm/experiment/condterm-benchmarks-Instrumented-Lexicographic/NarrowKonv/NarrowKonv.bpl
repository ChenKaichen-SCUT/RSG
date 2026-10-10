function {:existential true} b0(t : int, range : int %FD%, TR1:int, TR2:int, TR3:int): bool;
function {:existential true} b1(t : int, range : int): bool;

procedure main()
{
    var t : int;
    var range %VD%, TR1, TR2, TR3: int;
    havoc t;
    range := 20;

    %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;

    while (0 <= t && t <= range)
    invariant b0(t, range %IC%, TR1, TR2, TR3);
    rec b1(t, range)
    {
	%BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
        if (!(0 == t && t == range)) {
            TR1 := 1;
            if (t == range) {
                TR2 := 1;
                t := 0;
                range := range-1;
            } else {
                TR3 := 1;
                t := t+1;
            }
        }

	%IT%
    }

    return;
}
