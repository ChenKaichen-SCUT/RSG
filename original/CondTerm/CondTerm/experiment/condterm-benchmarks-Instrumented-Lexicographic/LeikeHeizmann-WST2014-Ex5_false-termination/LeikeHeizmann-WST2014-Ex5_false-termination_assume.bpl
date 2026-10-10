/*
 * Program from Example 5 of
 * 2014WST - Leike, Heizmann - Geometric Series as Nontermination Arguments for Linear Lasso Programs
 *
 * Date: 2014-06-29
 * Author: Jan Leike
 */

function {:existential true} b0(a : int, b : int, olda : int %FD%): bool;
function {:existential true} b1(a : int, b : int, olda : int): bool;

procedure main() {
    var a : int;
    var b : int;
    var olda %VD%: int;
    havoc a;
    havoc b;
    havoc olda;

  %BE%

  assume ((a <= 6) || (b <= 6) || ((a + b <= 13) && (a + b <= 14) && (a + olda <= 7))); // CondTerm
    while (a >= 7)
        invariant b0(a,b,olda %IC%);
        rec b1(a, b, olda)
    {
    %BT%
        olda := a;
        a := b;
        b := olda + 1;

    %IT%
    }
    return;
}
