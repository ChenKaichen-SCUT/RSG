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
