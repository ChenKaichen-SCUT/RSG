function {:existential true} b0(a : int, b : int, i:int %Decl:i%): bool;
function {:existential true} b1(a : int, b : int): bool;

procedure main()
{
    var a : int;
    var b, i : int;
    a := 1;
    b := 2;

    assume(%M:i%);

  assume (a + b > 3); // CondTerm
    while (a + b < 5)
    invariant b0(a, b,i %Inv:i%);
    rec b1(a, b)
    {
        %assert(i > 0);%
        a := a - b;
        b := a + b;
        a := b - a;

        %i := i - 1;%
    }

    return;
}
