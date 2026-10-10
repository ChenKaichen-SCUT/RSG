/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from Cairo_true-termination.c
 */

function {:existential true} b0(x : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x, i : int;
    havoc x;

    if (x > 0) {
        assume(%M:i%);
  assume ((x > -1) && ((x <= 0) || (x > 1)) && ((x <= 2) || (x > 3)) && ((x <= 4) || (x > 5)) && ((x <= 6) || (x > 7)) && ((x <= 8) || (x > 9)) && ((x <= 10) || (x > 11)) && ((x <= 12) || (x > 13)) && ((x <= 14) || (x > 15)) && ((x <= 16) || (x > 17)) && ((x <= 18) || (x > 19)) && ((x <= 20) || (x > 21)) && ((x <= 22) || (x > 23)) && ((x <= 24) || (x > 25)) && ((x <= 26) || (x > 27)) && ((x <= 28) || (x > 29))); // CondTerm
        while (x != 0)
            invariant b0(x,i %Inv:i%);
            rec b1(x)
        {
            %assert(i > 0);%
            x := x - 2;

            %i := i - 1;%
        }
    }
    return;
}
