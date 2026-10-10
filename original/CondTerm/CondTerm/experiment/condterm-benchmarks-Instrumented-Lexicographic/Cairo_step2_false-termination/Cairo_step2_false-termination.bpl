/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from Cairo_true-termination.c
 */

function {:existential true} b0(x : int %FD%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x %VD%: int;
    havoc x;

    if (x > 0) {
        %BE%
        while (x != 0)
            invariant b0(x %IC%);
            rec b1(x)
        {
            %BT%
            x := x - 2;

            %IT%
        }
    }
    return;
}
