function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t : int;
    var b, i : int;
    havoc t;

    assume(%M:i%);

  assume (t > -1); // CondTerm
    while (t != 1 && t != 0) 
        invariant b0(t,i %Inv:i%);
        rec b1(t)
    {
        %assert(i > 0);%
        t := t - 2;

        %i := i - 1;%
    }

    return;
}
