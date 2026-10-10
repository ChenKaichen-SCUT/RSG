/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 */

function {:existential true} b0(x : int %FD%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x %VD%: int;
    havoc x;

  %BE%

    while (x > 1)
        invariant b0(x %IC%);
        rec b1(x)
    {
    %BT%
        x := 2 * x;

    %IT%
    }
    return;
}
