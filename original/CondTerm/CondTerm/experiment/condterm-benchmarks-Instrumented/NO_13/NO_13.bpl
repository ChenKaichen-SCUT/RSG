function {:existential true} b0(t : int, j : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j, i : int;
    j := 100;
    t := 0;

    assume(%M:i%);

    while (t < j)
    invariant b0(t, j,i %Inv:i%);
    rec b1(t, j)
    {
        %assert(i > 0);%
        if (51 < j) { t := t+1; j := j-1; }
        else { t := t-1; j := j+1; }

        %i := i - 1;%
    }

    return;
}
