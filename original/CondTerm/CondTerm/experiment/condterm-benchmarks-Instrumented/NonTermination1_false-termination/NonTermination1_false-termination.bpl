/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 */

function {:existential true} b0(x : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x, i : int;
    havoc x;

    assume(%M:i%);

    while (x > 1)
        invariant b0(x,i %Inv:i%);
        rec b1(x)
    {
        %assert(i > 0);%
        x := 2 * x;

        %i := i - 1;%
    }
    return;
}
