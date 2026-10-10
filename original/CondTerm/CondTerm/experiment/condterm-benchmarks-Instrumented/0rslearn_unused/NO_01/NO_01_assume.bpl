function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var c : int;
    var t, i : int;
    c := (24*6)*6;
    
    if (c <= 10) {
        t := 0;
  assume (t > 20); // CondTerm
        while (t < 100) {
            t := t+1;
        }
    }
    else {
        if (c <= 50) {
            t := 0;
            while (t < 101) {
                t := t+1;
            }
        }
        if (c <= 100) {
            t := 0;
            while (t < 102) {
                t := t+1;
            }
        }
        else {
            t := 0;

            assume(%M:i%);
            while (t < 103)
            invariant b0(t,i %Inv:i%);
            rec b1(t)
            {
                %assert(i > 0);%
                t := t+0;

                %i := i - 1;%
            }
        }
    }

    return ;
}
