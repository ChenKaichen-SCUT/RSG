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
