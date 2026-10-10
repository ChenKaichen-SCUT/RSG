function {:existential true} b0(a : int, b : int, r : int, i:int %Decl:i%): bool;
function {:existential true} b1(a : int, b : int, r : int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var r, i : int;
    havoc a;
    havoc b;

    assume(%M:i%);

    while (b > 0)
    invariant b0(a, b, r,i %Inv:i%);
    rec b1(a, b, r)
    {
        %assert(i > 0);%
        havoc r;
        // assume r < a - 1;
        b := a - 1 - r;
        a := a - 1 - r;

        %i := i - 1;%
    }

    return;
}
