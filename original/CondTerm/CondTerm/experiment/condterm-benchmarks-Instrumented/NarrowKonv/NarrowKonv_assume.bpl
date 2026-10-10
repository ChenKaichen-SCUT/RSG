function {:existential true} b0(t : int, range : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, range : int): bool;

procedure main()
{
    var t : int;
    var range, i : int;
    havoc t;
    range := 20;

    assume(%M:i%);

  assume ((t <= -1) || (range < t)); // CondTerm
    while (0 <= t && t <= range)
    invariant b0(t, range,i %Inv:i%);
    rec b1(t, range)
    {
        %assert(i > 0);%
        if (!(0 == t && t == range)) {
            if (t == range) {
                t := 0;
                range := range-1;
            } else {
                t := t+1;
            }
        }

        %i := i - 1;%
    }

    return;
}
