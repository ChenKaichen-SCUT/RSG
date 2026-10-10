function {:existential true} b0(t : int, range : int, up : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int, TR5:int): bool;
function {:existential true} b1(t : int, range : int, up : int): bool;

procedure main()
{
    var t : int;
    var range : int;
    var up %VD%, TR1, TR2, TR3, TR4, TR5: int;
    havoc t;
    range := 20;
    up := 0;

    %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;
  TR5 := 0; 
    
    while (0 <= t && t <= range)
    invariant b0(t, range, up %IC%, TR1, TR2, TR3, TR4, TR5); 
    rec b1(t, range, up)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
	TR4 := 0;
	TR5 := 0;
        if (t == 0) {
            TR1 := 1;
            up := 1;
        }
        if (t == range) {
            TR2 := 1;
            up := 0;
        }
        if (up == 1) {
            TR3 := 1;
            t := t+1;
        }
        if (up == 0) {
            TR4 := 1;
            t := t-1;
        }
        if (t == range-2) {
            TR5 := 1;
            range := range-1;
        }

	%IT%
    }
    
    return ;
}
