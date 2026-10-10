/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 */
function {:existential true} b0(x : int, oldx : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, oldx : int): bool;

procedure main() {
    var x : int;
    var oldx, i : int;
    havoc x;
    havoc oldx;

    assume(%M:i%);

    while (x > 1 && x >= 2 * oldx)
        invariant b0(x, oldx,i %Inv:i%);
        rec b1(x, oldx)
    {
        %assert(i > 0);%
        oldx := x;
        havoc x;
        /* assume x > 1 && x >= 2 * oldx; */

        %i := i - 1;%
    }
    return;
}
