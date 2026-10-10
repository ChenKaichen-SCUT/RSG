function {:existential true} b0(t : int, range : int, up : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, range : int, up : int): bool;

procedure main()
{
    var t : int;
    var range : int;
    var up, i : int;
    havoc t;
    range := 20;
    up := 0;

    assume(%M:i%);
    
  assume (((up <= -1) && (range < t)) || ((range <= 0) && (t - up <= -1)) || ((t <= -1) && (t - up <= -1)) || ((range < t) && (t - up <= -1)) || ((range < t) && (range - t < 1)) || ((range <= 0) && (up <= -1) && (range - t >= 1)) || ((range <= 0) && (up <= 0) && (range - t < 1)) || ((t <= -1) && (up <= -1) && (range - t >= 1)) || ((t <= -1) && (up <= 0) && (range - t < 1))); // CondTerm
    while (0 <= t && t <= range)
    invariant b0(t, range, up,i %Inv:i%); 
    rec b1(t, range, up)
    {
        %assert(i > 0);%
        if (t == 0) {
            up := 1;
        }
        if (t == range) {
            up := 0;
        }
        if (up == 1) {
            t := t+1;
        }
        if (up == 0) {
            t := t-1;
        }
        if (t == range-2) {
            range := range-1;
        }

        %i := i - 1;%
    }
    
    return ;
}
