function {:existential true} b0(j : int, fac : int, t: int %FD%): bool;
function {:existential true} b1(j : int, fac : int, t: int): bool;

procedure main()
{
    var j : int;
    var t : int;
    var fac %VD%: int;
    havoc j;
    t := 1;
    fac := 1;

  %BE%

    while (j != fac) 
    invariant b0(j, fac, t %IC%);
    rec b1(j, fac, t)
    {
    %BT%
        fac := fac * t;
        t := t+1;

    %IT%
    }
	
    return ;
}
