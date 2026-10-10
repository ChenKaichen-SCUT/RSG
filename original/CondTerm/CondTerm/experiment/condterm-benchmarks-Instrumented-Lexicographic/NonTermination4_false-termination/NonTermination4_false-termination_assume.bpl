/*
 * Date: 2013-12-20
 * Author: leike@informatik.uni-freiburg.de
 *
 * Difficult example for non-termination
 *
 * y = x^log_2(3)
 */

function {:existential true} b0(x : int, y : int %FD%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y %VD%: int;

    x := 1;
    y := 2;

  %BE%

  assume (x <= -1); // CondTerm
    while (x >= 0)
        invariant b0(x,y %IC%);
        rec b1(x, y)
    {
    %BT%
        x := 2 * x;
        y := 3 * y;

    %IT%
    }
    return;
}
