/*
 * Program from Example 6 of
 * 2014WST - Leike, Heizmann - Geometric Series as Nontermination Arguments for Linear Lasso Programs
 *
 * Date: 2014-06-29
 * Author: Jan Leike
 */

function {:existential true} b0(a : int, b : int, i:int %Decl:i%): bool;
function {:existential true} b1(a : int, b : int): bool;

procedure main() {
    var a : int;
    var b, i : int;
    havoc a;
    havoc b;

    assume(%M:i%);

    while (a >= 1 && b >= 1)
        invariant b0(a,b,i %Inv:i%);
        rec b1(a, b)
    {
        %assert(i > 0);%
        a := 2 * a;
        b := 3 * b;

        %i := i - 1;%
    }
    return;
}
