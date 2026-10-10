/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

function {:existential true} b0(x : int, t : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int, TR5:int, TR6:int, TR7:int, TR8:int): bool;
function {:existential true} b1(x : int, t : int): bool;

procedure main() {
    var x : int;
    var t %VD%, TR1, TR2, TR3, TR4, TR5, TR6, TR7, TR8: int;
    havoc x;

    %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;
  TR5 := 0; 
  TR6 := 0;
  TR7 := 0;
  TR8 := 0;

  assume (((t <= 0) && (t > -1)) || ((x <= -1) && (x <= 0)) || ((x <= -1) && (t > -1))); // CondTerm
    while (x >= 0)
        invariant b0(x,t %IC%, TR1, TR2, TR3, TR4, TR5);
        rec b1(x, t)
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
        havoc t;
        if (t != 0) {
            TR1 := 1;
            x := x + 1;
        } else {
            TR2 := 1;
            havoc t;
            if (t != 0) {
                TR3 := 1;
                x := x + 2;
            } else {
                TR4 := 1;
                havoc t;
                if (t != 0) {
                    TR5 := 1;
                    x := x + 3;
                } else {
                    TR6 := 1;
                    havoc t;
                    if (t != 0) {
                        TR7 := 1;
                        x := x + 4;
                    } else {
                        TR8 := 1;
                        x := -1;
                    }
                }
            }
        }

	%IT%
    }
    return;
}
