function {:existential true} b0(t : int, j : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int, TR5:int, TR6:int, TR7:int, TR8:int, TR9:int, TR10:int, TR11:int, TR12:int): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j %VD%, TR1, TR2, TR3, TR4, TR5, TR6, TR7, TR8, TR9, TR10, TR11, TR12: int;

    havoc t;
    j := t;

    %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;
  TR5 := 0; 
  TR6 := 0;
  TR7 := 0;
  TR8 := 0;
  TR9 := 0;
  TR10 := 0;
  TR11 := 0;
  TR12 := 0;

    while (t != 0)
        invariant b0(t, j %IC%, TR1, TR2, TR3, TR4, TR5, TR6, TR7, TR8, TR9, TR10, TR11, TR12);
        rec b1(t, j)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
	TR4 := 0;
	TR5 := 0;
	TR6 := 0;
	TR7 := 0;
    TR8 := 0;
  TR9 := 0;
  TR10 := 0;
  TR11 := 0;
  TR12 := 0;
        if (t >= j) {
            TR1 := 1;
            t := t+1;
            if (j < 5) {
                TR2 := 1;
                j := j+1;
                if (t-j>2) {
                    TR3 := 1;
                    t := t+1;
                } else {
                    TR4 := 1;
                    j := j+1;
                }
            } else {
                TR5 := 1;
                j := j-1;
            }
        } else {
            TR6 := 1;
            if (t > 0 && j < 0) {
                TR7 := 1;
                t := t-1;
                if (j < -1) {
                    TR8 := 1;
                    j := j+1;
                } else {
                    TR9 := 1;
                    t := t+1;
                }
            } else {
                TR10 := 1;
                t := t+1;
                if (j*2 > t) {
                    TR11 := 1;
                    j := j-1;
                } else {
                    TR12 := 1;
                    j := j+1;
                }
            }
        }

        %IT%
    }

    return;
}
