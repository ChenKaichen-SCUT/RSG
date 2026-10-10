function {:existential true} b0(j : int, i:int %Decl:i%): bool;
function {:existential true} b1(j : int): bool;

procedure main()
{
    var t : int;
    var j, i : int;
    havoc t;

    while (t < 10) {
        j := t;
        assume(%M:i%);
        while (j > 5)
            invariant b0(j,i %Inv:i%);
            rec b1(j)
        {
            %assert(i > 0);%
            j := j+1;

            %i := i - 1;%
        }
        t := t+1;
    }

    return ;
}
