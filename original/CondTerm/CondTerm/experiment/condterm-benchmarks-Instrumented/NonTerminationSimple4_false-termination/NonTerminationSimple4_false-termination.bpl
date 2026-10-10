/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 * Does not terminate for y >= 5.
 */

function {:existential true} b0(x : int, y : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y, i : int;
    havoc x;
    havoc y;

    if (y >= 5) {

        assume(%M:i%);
        while (x >= 0)
            invariant b0(x,y,i %Inv:i%);
            rec b1(x, y)
        {
            %assert(i > 0);%
            y := y - 1;

            %i := i - 1;%
        }
    }
    return;
}
