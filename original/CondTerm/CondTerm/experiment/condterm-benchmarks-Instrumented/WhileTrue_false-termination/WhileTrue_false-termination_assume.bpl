/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Very simple example for non-termination
 */

function {:existential true} b0(x : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x, i : int;
    havoc x;

    assume(%M:i%);

  assume (false); // CondTerm
    while (true)
        invariant b0(x,i %Inv:i%);
        rec b1(x)
    {
        %assert(i > 0);%

        %i := i - 1;%
    }
    return;
}
