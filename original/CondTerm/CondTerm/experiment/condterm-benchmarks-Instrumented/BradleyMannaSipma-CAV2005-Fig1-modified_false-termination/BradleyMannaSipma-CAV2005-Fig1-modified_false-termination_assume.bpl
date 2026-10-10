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

function {:existential true} b0(y1 : int, y2 : int, i:int %Decl:i%): bool;
function {:existential true} b1(y1 : int, y2 : int): bool;

procedure main() {
    var y1 : int;
    var y2, i : int;

    if (y1 >= 0 && y2 >= 0) {
        assume(%M:i%);
  assume (((y1 <= 0) && (y2 <= 0)) || ((y1 > 0) && (y2 > 0))); // CondTerm
        while (y1 != y2)
            invariant b0(y1,y2,i %Inv:i%);
            rec b1(y1, y2)
        {
            %assert(i > 0);%
            if (y1 > y2) {
                y1 := y1 - y2;
            } else {
                y2 := y2 - y1;
            }

            %i := i - 1;%
        }
    }
    return;
}
