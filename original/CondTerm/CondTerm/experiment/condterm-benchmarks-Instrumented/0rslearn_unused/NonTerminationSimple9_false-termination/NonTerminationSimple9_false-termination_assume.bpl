/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

function {:existential true} b0(x : int, t: int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, t: int): bool;

procedure main() {
    var x : int;
    var t, i : int;
    havoc x;
    havoc t;

    assume(%M:i%);

  assume ((t <= -1) || (x <= -1)); // CondTerm
    while (x >= 0)
        invariant b0(x,t,i %Inv:i%);
        rec b1(x, t)
    {
        %assert(i > 0);%
        havoc t;
        x := x + t;

        %i := i - 1;%
    }
    return;
}
