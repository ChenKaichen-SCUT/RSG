/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 */
function {:existential true} b0(x : int, oldx : int %FD%): bool;
function {:existential true} b1(x : int, oldx : int): bool;

procedure main() {
    var x : int;
    var oldx %VD%: int;
    havoc x;
    havoc oldx;

  %BE%

    while (x > 1 && x >= 2 * oldx)
        invariant b0(x, oldx %IC%);
        rec b1(x, oldx)
    {
    %BT%
        oldx := x;
        havoc x;
        /* assume x > 1 && x >= 2 * oldx; */

    %IT%
    }
    return;
}
