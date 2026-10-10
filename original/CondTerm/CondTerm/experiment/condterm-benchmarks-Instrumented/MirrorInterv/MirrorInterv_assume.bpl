function {:existential true} b0(t : int, range : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, range : int): bool;

procedure main()
{
    var t : int;
    var range, i : int;
    havoc t;
    range := 20;

    assume(%M:i%);

  assume (((range <= 19) || (range + t <= -1) || (range + t > 10)) && ((range <= 19) || (range < t) || (range + t <= 10) || (range - t >= 5)) && (((range <= 19) && (t > -3)) || ((t > -3) && (t > 0)) || ((range <= 19) && (range + t <= 6)) || ((t > -3) && (range + t <= 9)) || ((t > 0) && (range + t <= 6)) || ((range + t <= 6) && (range + t <= 9)))); // CondTerm
    while (t >= -range && t <= range) 
    invariant b0(t, range,i %Inv:i%);
    rec b1(t, range)
    {
        %assert(i > 0);%
        if (range-t < 5 || range+t < 5) {
            t := t*(-1);
        } else {
            range := range+1;
            t := t-1;
            if (t == 0) {
                range := -1;
            }
        }

        %i := i - 1;%
    }
    
    return;
}
