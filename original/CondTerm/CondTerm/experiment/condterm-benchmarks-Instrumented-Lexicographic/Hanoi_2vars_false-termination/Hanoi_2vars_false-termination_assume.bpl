function {:existential true} b0(x : int, y : int %FD%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y %VD%: int;
    havoc x;
    havoc y;

  %BE%

  assume ((x < 1) || ((y < -1) && (y < 0)) || ((y < 0) && (x + y < 1))); // CondTerm
    while (x > 0)
        invariant b0(x,y %IC%);
        rec b1(x, y)
    {
    %BT%
        x := x + y;
        y := y + 1;

    %IT%
    }
    return;
}
