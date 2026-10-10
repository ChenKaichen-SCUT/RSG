function {:existential true} b0(b : int, c: int, a: int, r : int %FD%): bool;
function {:existential true} b1(b : int, c: int, a: int, r : int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var c : int;
    var r %VD%: int;
    havoc a;
    havoc b;
    havoc c;

  %BE%

  assume (((b <= c) || (r <= -6) || (r > -3) || (a < c) || (b + c > 20) || (a - c >= 1)) && ((r <= -3) || (r > -2) || (a < c) || (b + r <= 6) || (b + c > 17) || (a - c >= 1)) && ((a < c) || ((a >= b) && (b <= c)) || ((a >= b) && (r > -1)) || ((b <= c) && (r > -4)) || ((r > -4) && (r > -1)) || (a - c >= 1) || ((b <= c) && (c + r > 5)) || ((r > -1) && (c + r > 5)) || ((a >= b) && (c - r > 9)) || ((r > -4) && (c - r > 9)) || ((c + r > 5) && (c - r > 9)))); // CondTerm
    while ((b - c >= 1) && (a == c))
    invariant b0(b, c, a, r %IC%);
    rec b1(b, c, a, r)
    {
    %BT%
        havoc r;
        b := 10;
        c := c + 1 + r;
        a := c;

    %IT%
    }

    return;
}
