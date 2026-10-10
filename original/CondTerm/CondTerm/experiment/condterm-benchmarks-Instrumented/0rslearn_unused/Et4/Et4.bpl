function {:existential true} b0(b : int, c: int, a: int, r : int, i:int %Decl:i%): bool;
function {:existential true} b1(b : int, c: int, a: int, r : int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var c : int;
    var r, i : int;
    havoc a;
    havoc b;
    havoc c;

    assume(%M:i%);

    while ((b - c >= 1) && (a == c))
    invariant b0(b, c, a, r,i %Inv:i%);
    rec b1(b, c, a, r)
    {
        %assert(i > 0);%
        havoc r;
        b := 10;
        c := c + 1 + r;
        a := c;

        %i := i - 1;%
    }

    return;
}
