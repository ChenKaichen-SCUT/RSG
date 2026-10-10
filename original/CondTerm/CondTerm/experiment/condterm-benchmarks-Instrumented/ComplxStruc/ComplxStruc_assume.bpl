function {:existential true} b0(t : int, j : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j, i : int;

    havoc t;
    j := t;

    assume(%M:i%);

  assume (t <= 0); // CondTerm
    while (t != 0)
        invariant b0(t, j,i %Inv:i%);
        rec b1(t, j)
    {
        %assert(i > 0);%
        if (t >= j) {
            t := t+1;
            if (j < 5) {
                j := j+1;
                if (t-j>2) {
                    t := t+1;
                } else {
                    j := j+1;
                }
            } else {
                j := j-1;
            }
        } else {
            if (t > 0 && j < 0) {
                t := t-1;
                if (j < -1) {
                    j := j+1;
                } else {
                    t := t+1;
                }
            } else {
                t := t+1;
                if (j*2 > t) {
                    j := j-1;
                } else {
                    j := j+1;
                }
            }
        }

        %i := i - 1;%
    }

    return;
}
