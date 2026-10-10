/*
 * Program from Fig.1 of
 * 2005CAV - Bradley,Manna,Sipma - Linear Ranking with Reachability
 * Modified version that can be nonterminating because we allow that inputs of
 * gcd may be zero.
 *
 * Date: 12.12.2013
 * Author: heizmann@informatik.uni-freiburg.de
 *
 */

function {:existential true} b0(y1 : int, y2 : int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(y1 : int, y2 : int): bool;

procedure main() {
    var y1 : int;
    var y2 %VD%, TR1, TR2: int;

    if (y1 >= 0 && y2 >= 0) {
        %BE%
  TR1 := 0;
  TR2 := 0;
        while (y1 != y2)
            invariant b0(y1,y2 %IC%, TR1, TR2);
            rec b1(y1, y2)
        {
            %BT%
	TR1 := 0;
	TR2 := 0;
            if (y1 > y2) {
                TR1 := 1;
                y1 := y1 - y2;
            } else {
                TR2 := 1;
                y2 := y2 - y1;
            }

            %IT%
        }
    }
    return;
}
