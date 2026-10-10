/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from Mysore_true-termination.c
 */

function {:existential true} b0(x : int, c : int %FD%): bool;
function {:existential true} b1(x : int, c : int): bool;

procedure main() {
    var x : int;
    var c %VD%: int;
    havoc x;
    havoc c;

  %BE%

    if (c < 0) {
        while (x + c >= 0)
            invariant b0(x,c %IC%);
            rec b1(x, c)
        {
    %BT%
            x := x - c;
            c := c - 1;

    %IT%
        }
    }

}
