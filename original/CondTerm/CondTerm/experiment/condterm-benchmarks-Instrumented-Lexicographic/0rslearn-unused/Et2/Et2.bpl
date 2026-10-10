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
