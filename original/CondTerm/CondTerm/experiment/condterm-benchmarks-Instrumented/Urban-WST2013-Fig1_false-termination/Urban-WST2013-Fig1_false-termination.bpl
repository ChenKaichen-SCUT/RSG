/*
 * Program from Fig.2 of
 * 2013WST - Urban - Piecewise-Defined Ranking Functions
 *
 * Date: 12.12.2012
 * Author: heizmann@informatik.uni-freiburg.de
 *
 */

function {:existential true} b0(x : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x, i : int;
    havoc x;

    assume(%M:i%);

    while (x <= 10)
        invariant b0(x,i %Inv:i%);
        rec b1(x)
    {
        %assert(i > 0);%
        if (x > 6) {
            x := x + 2;
        }

        %i := i - 1;%
    }
    return;
}
