/*
 * Date: 2013-12-20
 * Author: leike@informatik.uni-freiburg.de
 *
 * Difficult example for non-termination
 *
 * y = x^log_2(3)
 */

function {:existential true} b0(x : int, y : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y, i : int;

    x := 1;
    y := 2;

    assume(%M:i%);

  assume (x <= -1); // CondTerm
    while (x >= 0)
        invariant b0(x,y,i %Inv:i%);
        rec b1(x, y)
    {
        %assert(i > 0);%
        x := 2 * x;
        y := 3 * y;

        %i := i - 1;%
    }
    return;
}
