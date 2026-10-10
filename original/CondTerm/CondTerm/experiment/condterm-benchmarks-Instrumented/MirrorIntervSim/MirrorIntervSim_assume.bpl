function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t, i : int;
    havoc t;

    assume(%M:i%);
    
  assume (((t <= -6) && (t <= 30)) || ((t <= -6) && (t > 35)) || ((t <= 30) && (t > -1)) || ((t > -1) && (t > 35))); // CondTerm
    while (t != 0) 
    invariant b0(t,i %Inv:i%);
    rec b1(t)
    {
        %assert(i > 0);%
        if (-5 <= t && t <= 35) {
            if (t < 0) {
                t := -5;
            } else {
                if (t > 30) {
                    t := 35;
                } else {
                    t := t-1;
                }	
            }					
        } else {
            t := 0;
        }

        %i := i - 1;%
    }
    
    return ;
}
