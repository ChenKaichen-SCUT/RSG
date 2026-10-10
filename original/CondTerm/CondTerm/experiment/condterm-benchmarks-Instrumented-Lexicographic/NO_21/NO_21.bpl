function {:existential true} b0(t : int %FD%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t %VD%: int;
    t := 0;

  %BE%
    
    while (t < 100)
    invariant b0(t %IC%);
    rec b1(t)
    {
    %BT%
        t := t+1;
        t := t-1;

    %IT%
    }
    
    return ;
}
