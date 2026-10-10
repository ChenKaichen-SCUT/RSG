/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

function {:existential true} b0(x : int, c : int %FD%): bool;
function {:existential true} b1(x : int, c : int): bool;

procedure main() {
    var x : int;
    var c %VD%: int;
    havoc x;
    havoc c;

if (c == 0) {
  %BE%
    while (x >= 0)
        invariant b0(x,c %IC%);
        rec b1(x, c)
    {
    %BT%
        x := x + c;

    %IT%
    }
}
    return;
}
