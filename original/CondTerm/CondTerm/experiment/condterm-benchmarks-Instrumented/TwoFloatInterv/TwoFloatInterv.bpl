function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t, i : int;
    havoc t;

    assume(%M:i%);
    
    while (t > 0 && t < 50) 
    invariant b0(t,i %Inv:i%);
    rec b1(t)
    {
        %assert(i > 0);%
        if (t < 20) {
            t := t-1;
        }
        if (t > 10) {
            t := t+1;
        }
        if (30 <= t && t <= 40) {
            t := t-1;
        }
        
        %i := i - 1;%
    }
    
    return;
}
