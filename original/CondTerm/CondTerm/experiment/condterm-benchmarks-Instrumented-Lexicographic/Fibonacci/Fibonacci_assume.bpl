function {:existential true} b0(j : int, n : int, _i : int, t : int %FD%): bool;
function {:existential true} b1(j : int, n : int, _i : int, t : int): bool;

procedure main()
{
    var n : int;
    var _i : int;
    var j : int;
    var t %VD%: int;
    havoc n;
    _i := 0;
    j := 1;
    t := 0;

  %BE%
    
  assume (((_i <= -1) || ((j <= 0) && (j <= n)) || ((j <= n) && (n > -1))) && ((n <= 3) || (j > 1) || (n > 4) || (_i + j > 1) || (j - t <= -1) || (j - t > 3)) && ((_i <= 0) || (j <= 0) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 1) || (_i + t <= 1) || (_i + j > 2) || (j - t <= -1) || (j - t > 3)) && ((n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 4) || (_i + t <= 1) || (_i - j >= 4) || (j - t <= -1) || (j - n > -1) || (j - t > 3)) && ((_i <= -1) || (j <= n) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 2) || (_i + t <= 1) || (_i - j >= 4) || (j - n <= -1) || (j - t <= -1) || (j - t > 3)) && ((_i >= j) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 2) || (_i + t <= 1) || (_i + j > 3) || (_i - j >= 4) || (j - t <= -1) || (j - n > -1) || (j - t > 3))); // CondTerm
    while (j != n) 
    invariant b0(j, n, _i, t %IC%);
    rec b1(j, n, _i, t)
    {
    %BT%
        t := j+_i;
        _i := j;
        j := t;

    %IT%
    }
	
    return ;
}
