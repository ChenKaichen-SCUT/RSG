/*
 * Date: 2013-05-02
 * Author: heizmann@informatik.uni-freiburg.de
 *
 */

function {:existential true} b0(x : int %FD%): bool;
function {:existential true} b1(x : int): bool;

procedure main() {
    var x %VD%: int;
    havoc x;

  %BE%

  assume (false); // CondTerm
    while (true)
        invariant b0(x %IC%);
        rec b1(x)
    {
    %BT%
        x := 2;

    %IT%
    }
    return;
}
