/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

function {:existential true} b0(x : int, t : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, t : int): bool;

procedure main() {
    var x : int;
    var t, i : int;
    havoc x;

    assume(%M:i%);

    while (x >= 0)
        invariant b0(x,t,i %Inv:i%);
        rec b1(x, t)
    {
        %assert(i > 0);%
        havoc t;
        // assume t == 0 || x - 1 >= 0;
        if (t != 0) {
            x := x - 1;
        } else {
            x := x + 1;
        }

        %i := i - 1;%
    }

    return;
}
