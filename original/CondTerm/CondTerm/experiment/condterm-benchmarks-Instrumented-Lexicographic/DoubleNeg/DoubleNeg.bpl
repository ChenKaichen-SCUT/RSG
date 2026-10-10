function {:existential true} b0(t:int, j:int %FD%): bool;
function {:existential true} b1(t:int, j:int): bool;

procedure main()
{
    var t: int;
    var j %VD%: int;
    havoc t;
    havoc j;

    %BE%
    
    while (t*j > 0)
    invariant b0(t, j %IC%);
    rec b1(t, j)
    {
    %BT%
        t := t - 1;
        j := j - 1;

    %IT%
    }
    
    return;
}
