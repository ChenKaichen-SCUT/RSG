function {:existential true} b0(a : int, b : int %FD%): bool;
function {:existential true} b1(a : int, b : int): bool;

procedure main()
{
    var a : int;
    var b %VD%: int;
    a := 1;
    b := 2;

  %BE%

  assume (a + b > 3); // CondTerm
    while (a + b < 5)
    invariant b0(a, b %IC%);
    rec b1(a, b)
    {
    %BT%
        a := a - b;
        b := a + b;
        a := b - a;

    %IT%
    }

    return;
}
