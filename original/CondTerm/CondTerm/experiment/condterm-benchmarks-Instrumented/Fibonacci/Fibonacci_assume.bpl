function {:existential true} b0(j : int, n : int, _i : int, t : int, i:int %Decl:i%): bool;
function {:existential true} b1(j : int, n : int, _i : int, t : int): bool;

procedure main()
{
    var n : int;
    var _i : int;
    var j : int;
    var t, i : int;
    havoc n;
    _i := 0;
    j := 1;
    t := 0;

    assume(%M:i%);
    
  assume (((_i <= -1) || ((j <= 0) && (j <= n)) || ((j <= n) && (n > -1))) && ((n <= 3) || (j > 1) || (n > 4) || (_i + j > 1) || (j - t <= -1) || (j - t > 3)) && ((_i <= 0) || (j <= 0) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 1) || (_i + t <= 1) || (_i + j > 2) || (j - t <= -1) || (j - t > 3)) && ((n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 4) || (_i + t <= 1) || (_i - j >= 4) || (j - t <= -1) || (j - n > -1) || (j - t > 3)) && ((_i <= -1) || (j <= n) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 2) || (_i + t <= 1) || (_i - j >= 4) || (j - n <= -1) || (j - t <= -1) || (j - t > 3)) && ((_i >= j) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 2) || (_i + t <= 1) || (_i + j > 3) || (_i - j >= 4) || (j - t <= -1) || (j - n > -1) || (j - t > 3))); // CondTerm
    while (j != n) 
    invariant b0(j, n, _i, t,i %Inv:i%);
    rec b1(j, n, _i, t)
    {
        %assert(i > 0);%
        t := j+_i;
        _i := j;
        j := t;

        %i := i - 1;%
    }
	
    return ;
}
