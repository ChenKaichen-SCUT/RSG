function {:existential true} b0(j : int, fac : int, t: int, i:int %Decl:i%): bool;
function {:existential true} b1(j : int, fac : int, t: int): bool;

procedure main()
{
    var j : int;
    var t : int;
    var fac, i : int;
    havoc j;
    t := 1;
    fac := 1;

    assume(%M:i%);

    while (j != fac) 
    invariant b0(j, fac, t,i %Inv:i%);
    rec b1(j, fac, t)
    {
        %assert(i > 0);%
        fac := fac * t;
        t := t+1;

        %i := i - 1;%
    }
	
    return ;
}
