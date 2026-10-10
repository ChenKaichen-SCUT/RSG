/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 */

function {:existential true} b0(x : int, y : int, z : int %FD%): bool;
function {:existential true} b1(x : int, y : int, z : int): bool;

procedure main() {
    var x : int;
    var y : int;
    var z %VD%: int;
    havoc x;
    havoc y;
    havoc z;

  %BE%

    while (x > 0)
        invariant b0(x,y,z %IC%);
        rec b1(x, y, z)
    {
    %BT%
        x := x + y;
        y := y + z;
        z := z + 1;

    %IT%
    }
    return;
}
