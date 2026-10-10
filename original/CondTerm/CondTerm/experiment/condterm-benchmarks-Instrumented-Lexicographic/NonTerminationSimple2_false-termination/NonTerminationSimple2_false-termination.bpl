/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Simple example for non-termination
 */

function {:existential true} b0(x : int %FD%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x %VD%: int;
    havoc x;

  %BE%

    while (x >= 0)
        invariant b0(x %IC%);
        rec b1(x)
    {
    %BT%
        x := x + 1;

    %IT%
    }
    return;
}
