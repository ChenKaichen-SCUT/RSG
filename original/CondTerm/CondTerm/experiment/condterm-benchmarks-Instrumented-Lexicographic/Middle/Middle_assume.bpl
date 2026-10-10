function {:existential true} b0(t : int, j : int %FD%): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j %VD%: int;
    havoc t;
    havoc j;

  %BE%
    
  assume ((j - t < 1) && ((j <= -t) || (j + t > 1)) && ((j + t <= -8) || (j + t > -7)) && ((j + t <= -6) || (j + t > -5)) && ((j + t <= -4) || (j + t > -3)) && ((j + t <= -2) || (j + t > -1)) && ((j + t <= 2) || (j + t > 3)) && ((j + t <= 4) || (j + t > 5)) && ((j + t <= 6) || (j + t > 7)) && ((j + t <= 8) || (j + t > 9)) && ((j + t <= 10) || (j + t > 11)) && ((j + t <= 14) || (j + t > 15)) && ((j + t <= 16) || (j + t > 17)) && ((j + t <= 18) || (j + t > 19)) && ((j >= t) || (t > -2) || (j - t >= 1) || (j - t < -1))); // CondTerm
    while (t != j) 
    invariant b0(t, j %IC%);
    rec b1(t, j)
    {
    %BT%
        t := t-1;
        j := j+1;

    %IT%
    }
    
    return ;
}
