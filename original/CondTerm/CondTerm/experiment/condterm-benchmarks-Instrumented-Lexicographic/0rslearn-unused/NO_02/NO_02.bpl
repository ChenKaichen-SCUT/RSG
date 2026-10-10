function {:existential true} b0(j : int %FD%): bool;
function {:existential true} b1(j : int): bool;

procedure main()
{
    var t : int;
    var j %VD%: int;
    t := 0;

    while (t < 100)
    {
        j := 0;

  %BE%
        while (j < 1)
            invariant b0(j %IC%);
            rec b1(j)
        {
    %BT%
            j := j+0;

    %IT%
        }
        t := t+1;
    }

    return ;
}
