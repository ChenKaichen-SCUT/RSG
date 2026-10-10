function {:existential true} b0(t : int %FD%): bool;
function {:existential true} b1(t : int): bool;
function {:existential true} b2(j : int): bool;

procedure main()
{
    var t : int;
    var j %VD%: int;
    t := 0;

  %BE%
    
    while (t < 100) 
    invariant b0(t %IC%);
    rec b1(t)
    {
    %BT%
        j := 0;
        while (j < 1) 
            invariant b2(j);
        {
            j := j+1;
        }
        t := t+0;

    %IT%
    }
    
    return ;
}
