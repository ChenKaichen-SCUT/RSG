function {:existential true} b0(t : int, j : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j, i : int;
    j := 100;
    t := 0;

    assume(%M:i%);

  assume (((j + t > 100) || (j - t < 87)) && ((j > 81) || (j - t >= 64) || (j - t < 61)) && ((j + t > 100) || (j - t >= 71) || (j - t < 64)) && ((j + t > 100) || (j - t >= 77) || (j - t < 71)) && ((j + t > 100) || (j - t >= 81) || (j - t < 77)) && ((j + t > 100) || (j - t >= 87) || (j - t < 81)) && ((j + t > 101) || (j - t >= 5) || (j - t < 1)) && ((j + t > 101) || (j - t >= 50) || (j - t < 5)) && ((j + t > 101) || (j - t >= 56) || (j - t < 50)) && ((j + t > 101) || (j - t >= 61) || (j - t < 56))); // CondTerm
    while (t < j)
    invariant b0(t, j,i %Inv:i%);
    rec b1(t, j)
    {
        %assert(i > 0);%
        if (51 < j) { t := t+1; j := j-1; }
        else { t := t-1; j := j+1; }

        %i := i - 1;%
    }

    return;
}
