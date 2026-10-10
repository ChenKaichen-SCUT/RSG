function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t, i : int;
    havoc t;

    assume(%M:i%);

    while (t > 10)
    invariant b0(t,i %Inv:i%);
    rec b1(t)
    {
        %assert(i > 0);%
        if (t == 25) {
            t := 30;
        }
        if (t <= 30) {
            t := t-1;
        } else {
            t := 20;
        }

        %i := i - 1;%
    }

    return ;
}
