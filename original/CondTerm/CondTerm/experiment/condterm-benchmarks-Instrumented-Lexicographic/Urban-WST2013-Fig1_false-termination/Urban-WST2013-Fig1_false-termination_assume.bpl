/*
 * Program from Fig.2 of
 * 2013WST - Urban - Piecewise-Defined Ranking Functions
 *
 * Date: 12.12.2012
 * Author: heizmann@informatik.uni-freiburg.de
 *
 */

function {:existential true} b0(x : int %FD%, TR1:int): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x %VD%, TR1: int;
    havoc x;

    %BE%
  TR1 := 0;

  assume ((x > 0) && (x > 1) && (x > 2) && (x > 3) && (x > 4) && (x > 5) && (x > 6)); // CondTerm
    while (x <= 10)
        invariant b0(x %IC%, TR1);
        rec b1(x)
    {
        %BT%
	TR1 := 0;
        if (x > 6) {
            TR1 := 1;
            x := x + 2;
        }

	%IT%
    }
    return;
}
