/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

function {:existential true} b0(x : int, t : int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(x : int, t : int): bool;

procedure main() {
    var x : int;
    var t %VD%, TR1, TR2: int;
    havoc x;

    %BE%
  TR1 := 0;
  TR2 := 0;

    while (x >= 0)
        invariant b0(x,t %IC%, TR1, TR2);
        rec b1(x, t)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
        havoc t;
        // assume t == 0 || x - 1 >= 0;
        if (t != 0) {
            TR1 := 1;
            x := x - 1;
        } else {
            TR2 := 1;
            x := x + 1;
        }

        %IT%
    }

    return;
}
