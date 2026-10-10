function {:existential true} b0(t : int, j : int %FD%): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j %VD%: int;
    j := 100;
    t := 0;

  %BE%
    
    while (t < j) 
    invariant b0(t, j %IC%);
    rec b1(t, j)
    {
    %BT%
        j := j+1;
        t := t+1;

    %IT%
    }
    
    return ;
}
