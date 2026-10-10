/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Does not terminate for c >= 0.
 */

function {:existential true} b0(x : int, c : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, c : int): bool;

procedure main() {
    var x : int;
    var c, i : int;
    havoc x;
    havoc c;

    assume(%M:i%);

    while (x >= 0)
        invariant b0(x,c,i %Inv:i%);
        rec b1(x, c)
    {
        %assert(i > 0);%
        x := x + c;

        %i := i - 1;%
    }
    return;
}
