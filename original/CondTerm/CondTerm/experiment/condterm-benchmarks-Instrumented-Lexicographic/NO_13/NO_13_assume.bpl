function {:existential true} b0(t : int, j : int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j %VD%, TR1, TR2: int;
    j := 100;
    t := 0;

    %BE%
  TR1 := 0;
  TR2 := 0;

  assume (((j + t > 100) || (j - t < 87)) && ((j > 81) || (j - t >= 64) || (j - t < 61)) && ((j + t > 100) || (j - t >= 71) || (j - t < 64)) && ((j + t > 100) || (j - t >= 77) || (j - t < 71)) && ((j + t > 100) || (j - t >= 81) || (j - t < 77)) && ((j + t > 100) || (j - t >= 87) || (j - t < 81)) && ((j + t > 101) || (j - t >= 5) || (j - t < 1)) && ((j + t > 101) || (j - t >= 50) || (j - t < 5)) && ((j + t > 101) || (j - t >= 56) || (j - t < 50)) && ((j + t > 101) || (j - t >= 61) || (j - t < 56))); // CondTerm
    while (t < j)
    invariant b0(t, j %IC%, TR1, TR2);
    rec b1(t, j)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
        if (51 < j) { 
            TR1 := 1;
            t := t+1; j := j-1; }
        else { 
            TR2 := 1;
            t := t-1; j := j+1; }

	%IT%
    }

    return;
}
