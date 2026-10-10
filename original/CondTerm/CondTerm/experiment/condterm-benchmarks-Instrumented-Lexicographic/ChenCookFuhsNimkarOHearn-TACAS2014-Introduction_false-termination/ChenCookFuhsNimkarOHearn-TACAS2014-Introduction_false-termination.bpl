/*
 * Program from the example depicted in the introduction of
 * 2014TACAS - Chen,Cook,Fuhs,Nimkar,O Hearn - Proving Nontermination via Safety
 *
 * Date: 2014-06-28
 * Author: Matthias Heizmann
 *
 */

function {:existential true} b0(n : int %FD%): bool;
function {:existential true} b1(n : int): bool;

procedure main() {
    var k : int;
    var n %VD%: int;

    if (k >= 0) {
        k := k;
    } else {
        n := -1;
    }

    %BE%

    while (n >= 0)
        invariant b0(n %IC%);
        rec b1(n)
    {
        %BT%
        havoc n;

        %IT%
    }

    n := 2;
    return;
}
