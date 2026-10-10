function {:existential true} b0(a : int, b : int, r : int %FD%): bool;
function {:existential true} b1(a : int, b : int, r : int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var r %VD%: int;
    havoc a;
    havoc b;

  %BE%

  assume (((r > -2) && (r > -1)) || ((a <= 0) && (a <= 1) && (r > -1)) || ((a <= 1) && (b <= 0) && (r > -1)) || ((a <= 0) && (a <= 1) && (a <= -r)) || ((a <= 0) && (a <= 1) && (b <= -r)) || ((a <= 0) && (r > -2) && (a <= -r)) || ((a <= 0) && (r > -2) && (b <= -r)) || ((a <= 0) && (r > -1) && (b + r <= -1)) || ((a <= 1) && (b <= 0) && (a <= -r)) || ((a <= 1) && (b <= 0) && (b <= -r)) || ((b <= 0) && (r > -2) && (a <= -r)) || ((b <= 0) && (r > -2) && (b <= -r)) || ((b <= 0) && (r > -1) && (b + r <= -1)) || ((a <= 0) && (a <= -r) && (b + r <= -1)) || ((a <= 0) && (b <= -r) && (b + r <= -1)) || ((b <= 0) && (a <= -r) && (b + r <= -1)) || ((b <= 0) && (b <= -r) && (b + r <= -1))); // CondTerm
    while (b > 0)
    invariant b0(a, b, r %IC%);
    rec b1(a, b, r)
    {
    %BT%
        havoc r;
        // assume r < a - 1;
        b := a - 1 - r;
        a := a - 1 - r;

    %IT%
    }

    return;
}
