function {:existential true} b0(t : int %FD%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t : int;
    var b %VD%: int;
    havoc t;

  %BE%

  assume (t > -1); // CondTerm
    while (t != 1 && t != 0) 
        invariant b0(t %IC%);
        rec b1(t)
    {
    %BT%
        t := t - 2;

    %IT%
    }

    return;
}
