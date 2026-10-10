function {:existential true} b0(t : int, up : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, up : int): bool;

procedure main()
{
    var t : int;
    var up, i : int;
    havoc t;
    up := 0;

    assume(%M:i%);
    
  assume ((t <= -1) || (t > 10)); // CondTerm
    while (0 <= t && t <= 10) 
    invariant b0(t, up,i %Inv:i%);
    rec b1(t, up)
    {
        %assert(i > 0);%
        if (t >= 10) {
            up := 0;
        }
        if (t <= 0) {
            up := 1;
        }
        if (up >= 1) {
            t := t+1;
        } else {
            t := t-1;
        }

        %i := i - 1;%
    }
    
    return ;
}
