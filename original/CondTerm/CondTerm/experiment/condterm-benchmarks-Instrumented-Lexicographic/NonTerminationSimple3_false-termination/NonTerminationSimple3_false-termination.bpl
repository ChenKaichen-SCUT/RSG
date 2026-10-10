/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Does not terminate for c >= 0.
 */

function {:existential true} b0(x : int, c : int %FD%): bool;
function {:existential true} b1(x : int, c : int): bool;

procedure main() {
    var x : int;
    var c %VD%: int;
    havoc x;
    havoc c;

  %BE%

    while (x >= 0)
        invariant b0(x,c %IC%);
        rec b1(x, c)
    {
    %BT%
        x := x + c;

    %IT%
    }
    return;
}
