/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Rotates x and y by 90 degrees
 * Does not terminate.
 */

function {:existential true} b0(x : int, y : int, oldx : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, oldx : int): bool;

procedure main() {
    var x : int;
    var y : int;
    var oldx, i : int;
    havoc x;
    havoc y;
    havoc oldx;

    assume(%M:i%);

    while (true)
        invariant b0(x,y,i %Inv:i%);
        rec b1(x, y, oldx)
    {
        %assert(i > 0);%
        oldx := x;
        x := -y;
        y := oldx;

        %i := i - 1;%
    }
    return;
}
