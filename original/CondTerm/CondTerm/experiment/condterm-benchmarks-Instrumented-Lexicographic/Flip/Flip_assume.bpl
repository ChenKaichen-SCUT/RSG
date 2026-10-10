function {:existential true} b0(_i : int, j : int %FD%): bool;
function {:existential true} b1(_i : int, j : int): bool;

procedure main()
{
    var _i : int;
    var j : int;
    var t %VD%: int;
    havoc _i;
    havoc j;
    t := 0;

  %BE%
    
  assume (((_i <= 0) || (j <= 0)) && ((_i <= 0) || (j > -1)) && ((j <= 0) || (_i > -1)) && ((_i > -1) || (j > -1))); // CondTerm
    while (_i != 0 && j != 0) 
    invariant b0(_i, j %IC%);
    rec b1(_i, j)
    {
    %BT%
        t := _i;
        _i := j;
        j := t;

    %IT%
    }
    
    return ;
}
