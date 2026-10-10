/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 */

function {:existential true} b0(x : int, y : int %FD%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y %VD%: int;
    havoc x;
    havoc y;

    if (x + y >= 0)
    {
  %BE%
        while (x > 0)
        invariant b0(x,y %IC%);
        rec b1(x, y)
        {
    %BT%
            x := x + x + y;
            y := y + 1;

    %IT%
        }
    }
    return;
}
