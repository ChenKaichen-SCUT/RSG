/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from Mysore_true-termination.c
 */

function {:existential true} b0(x : int, c : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, c : int): bool;

procedure main() {
    var x : int;
    var c, i : int;
    havoc x;
    havoc c;

    assume(%M:i%);

    if (c < 0) {
  assume ((c > -1) || (c + x <= -1)); // CondTerm
        while (x + c >= 0)
            invariant b0(x,c,i %Inv:i%);
            rec b1(x, c)
        {
            %assert(i > 0);%
            x := x - c;
            c := c - 1;

            %i := i - 1;%
        }
    }

}
