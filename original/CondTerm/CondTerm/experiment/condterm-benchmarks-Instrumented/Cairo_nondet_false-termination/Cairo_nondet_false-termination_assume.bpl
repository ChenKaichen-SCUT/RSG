/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from Cairo_true-termination.c
 */

function {:existential true} b0(x : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x : int;
    var y, i : int;
    havoc x;
    havoc y;

    assume(%M:i%);

    if (x > y) {
  assume (x > -1); // CondTerm
        while (x != 0)
            invariant b0(x,i %Inv:i%);
            rec b1(x)
        {
            %assert(i > 0);%
            x := x - 1;

            %i := i - 1;%
        }
    }
    return;
}
