/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 */

function {:existential true} b0(x : int, y : int, z : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, z : int): bool;

procedure main() {
    var x : int;
    var y : int;
    var z, i : int;
    havoc x;
    havoc y;
    havoc z;

    assume(%M:i%);

  assume (((x <= 0) || (x <= -y) || (y + z <= -1)) && ((x <= 0) || (x + y <= 1) || (y + z <= -1)) && ((x <= 0) || (x + y <= 2) || (x - z > 3)) && ((x <= 1) || (x <= -y) || (x + y <= 1) || (y + z <= -1)) && ((x <= 1) || (y <= -z) || (x + y <= 5) || (y + z <= -3)) && ((x <= 1) || (x <= y) || (x + y <= 7) || (y + z <= -3) || (y > -z)) && ((x <= 1) || (x <= -y) || (x + y <= 2) || (y + z <= -2) || (y + z > -1)) && ((x <= 0) || (x <= -y) || (x <= -z) || (x + y <= 1) || (y + z <= -2) || (y + z > -1)) && ((x <= 0) || ((y <= -1) && (x <= -y)) || ((z <= -1) && (x <= -y)) || ((y <= -1) && (y <= -z) && (x + z <= 2)) || ((y <= -1) && (y <= -z) && (y + z <= -1)) || ((z <= -1) && (y <= -z) && (x + z <= 2)) || ((z <= -1) && (y <= -z) && (y + z <= -1)))); // CondTerm
    while (x > 0)
        invariant b0(x,y,z,i %Inv:i%);
        rec b1(x, y, z)
    {
        %assert(i > 0);%
        x := x + y;
        y := y + z;
        z := z + x;

        %i := i - 1;%
    }
    return;
}
