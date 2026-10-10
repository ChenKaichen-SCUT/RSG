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
