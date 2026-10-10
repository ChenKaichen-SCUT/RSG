function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t, i : int;
    havoc t;

    assume(%M:i%);
    
  assume (((t <= 11) || (t > 19)) && ((t <= 11) || (t > 29)) && ((t <= 11) || (t > 30)) && ((t <= 11) || (t > 31)) && ((t <= 11) || (t > 32)) && ((t <= 11) || (t > 33)) && ((t <= 11) || (t > 34)) && ((t <= 11) || (t > 35)) && ((t <= 11) || ((t > 12) && (t > 13) && (t > 14) && (t > 15) && (t > 16) && (t > 17) && (t > 18)))); // CondTerm
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
