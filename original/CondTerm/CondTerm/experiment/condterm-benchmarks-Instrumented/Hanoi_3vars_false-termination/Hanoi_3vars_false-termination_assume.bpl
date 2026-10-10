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

  assume (((x <= 0) || (z <= -2) || (y + z <= 1) || (y - z <= -4)) && ((x <= 0) || (y <= -2) || (z <= -1) || (x + z <= 3) || (y - z <= -4)) && ((x <= 0) || (y <= -1) || ((z <= -2) && (z <= -1)) || ((z <= -1) && (y + z <= -1))) && ((x <= 0) || (x <= z) || (z <= 0) || (y + z > 1) || (x - z <= -1) || (y - z <= -3)) && ((x <= 0) || (x <= z) || (z <= -3) || (z > 0) || (y + z <= -1) || (y + z > 1) || (x - z <= 1) || (y - z <= -3)) && ((x <= 2) || (x <= z) || (z <= -3) || (y > 0) || (z > 0) || (y + z <= -2) || (y + z > -1) || (x - z <= 1) || (y - z <= -3))); // CondTerm
    while (x > 0)
        invariant b0(x,y,z,i %Inv:i%);
        rec b1(x, y, z)
    {
        %assert(i > 0);%
        x := x + y;
        y := y + z;
        z := z + 1;

        %i := i - 1;%
    }
    return;
}
