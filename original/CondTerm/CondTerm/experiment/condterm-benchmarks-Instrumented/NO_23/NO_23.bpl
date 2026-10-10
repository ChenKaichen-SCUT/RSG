function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t, i : int;
    t := 0;

    assume(%M:i%);
    
    while (t < 100) 
    invariant b0(t,i %Inv:i%);
    rec b1(t)
    {
        %assert(i > 0);%
        if (t < 50) { t := 51;}
        else { t := 49; }

        %i := i - 1;%
    }
    
    return;
}
