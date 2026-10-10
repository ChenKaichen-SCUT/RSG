/*
 * Program from the example depicted in the introduction of
 * 2014TACAS - Chen,Cook,Fuhs,Nimkar,O Hearn - Proving Nontermination via Safety
 *
 * Date: 2014-06-28
 * Author: Matthias Heizmann
 *
 */

function {:existential true} b0(n : int, i:int %Decl:i%): bool;
function {:existential true} b1(n : int): bool;

procedure main() {
    var k : int;
    var n, i : int;

    if (k >= 0) {
        k := k;
    } else {
        n := -1;
    }

    assume(%M:i%);

  assume (n <= -1); // CondTerm
    while (n >= 0)
        invariant b0(n,i %Inv:i%);
        rec b1(n)
    {
        %assert(i > 0);%
        havoc n;

        %i := i - 1;%
    }

    n := 2;
    return;
}
