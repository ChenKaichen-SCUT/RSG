function {:existential true} b0(t : int, j : int, tmp : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, j : int, tmp : int): bool;

procedure main()
{
    var t : int;
    var j : int;
    var r : int;
    var tmp, i : int;
    havoc t;
    havoc j;

    assume(%M:i%);

    while (t - j >= 1)
    invariant b0(t, j, tmp,i %Inv:i%);
    rec b1(t, j, tmp)
    {
        %assert(i > 0);%
        havoc tmp;
        t := t - tmp;
        havoc tmp;
        r := tmp + 1;
        j := j + r;

        %i := i - 1;%
    }

    return;
}
