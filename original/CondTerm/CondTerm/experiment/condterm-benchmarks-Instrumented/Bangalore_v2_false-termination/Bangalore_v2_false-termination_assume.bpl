/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 */

function {:existential true} b0(x : int, y : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y, i : int;

    if (y >= 0) {
        assume(%M:i%);
  assume ((x <= -1) || (y > 0)); // CondTerm
        while (x >= 0)
            invariant b0(x,y,i %Inv:i%);
            rec b1(x, y)
        {
            %assert(i > 0);%
            x := x - y;

            %i := i - 1;%
        }
    }
    return;
}
