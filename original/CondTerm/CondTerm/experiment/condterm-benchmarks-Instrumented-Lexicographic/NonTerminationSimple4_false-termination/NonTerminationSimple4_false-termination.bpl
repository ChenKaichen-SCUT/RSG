/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 * Does not terminate for y >= 5.
 */

function {:existential true} b0(x : int, y : int %FD%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y %VD%: int;
    havoc x;
    havoc y;

    if (y >= 5) {

  %BE%
        while (x >= 0)
            invariant b0(x,y %IC%);
            rec b1(x, y)
        {
    %BT%
            y := y - 1;

    %IT%
        }
    }
    return;
}
