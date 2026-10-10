/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

function {:existential true} b0(x : int, t: int %FD%): bool;
function {:existential true} b1(x : int, t: int): bool;

procedure main() {
    var x : int;
    var t %VD%: int;
    havoc x;
    havoc t;

  %BE%

    while (x >= 0)
        invariant b0(x,t %IC%);
        rec b1(x, t)
    {
    %BT%
        havoc t;
        x := x + t;

    %IT%
    }
    return;
}
