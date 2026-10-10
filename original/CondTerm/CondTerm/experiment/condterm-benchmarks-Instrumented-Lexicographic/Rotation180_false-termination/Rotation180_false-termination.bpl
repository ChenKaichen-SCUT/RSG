/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Rotates x and y by 90 degrees
 * Does not terminate.
 */

function {:existential true} b0(x : int, y : int, oldx : int %FD%): bool;
function {:existential true} b1(x : int, y : int, oldx : int): bool;

procedure main() {
    var x : int;
    var y : int;
    var oldx %VD%: int;
    havoc x;
    havoc y;
    havoc oldx;

  %BE%

    while (true)
        invariant b0(x,y %IC%);
        rec b1(x, y, oldx)
    {
    %BT%
        oldx := x;
        x := -y;
        y := oldx;

    %IT%
    }
    return;
}
