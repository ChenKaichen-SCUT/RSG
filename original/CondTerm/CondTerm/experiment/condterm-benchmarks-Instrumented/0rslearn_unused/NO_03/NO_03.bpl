function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;
function {:existential true} b2(j : int): bool;

procedure main()
{
    var t : int;
    var j, i : int;
    t := 0;

    assume(%M:i%);
    
    while (t < 100) 
    invariant b0(t,i %Inv:i%);
    rec b1(t)
    {
        %assert(i > 0);%
        j := 0;
        while (j < 1) 
            invariant b2(j);
        {
            j := j+1;
        }
        t := t+0;

        %i := i - 1;%
    }
    
    return ;
}
