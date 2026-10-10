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
