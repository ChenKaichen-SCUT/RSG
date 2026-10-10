function {:existential true} b0(_i : int, j : int, i:int %Decl:i%): bool;
function {:existential true} b1(_i : int, j : int): bool;

procedure main()
{
    var _i : int;
    var j : int;
    var t, i : int;
    havoc _i;
    havoc j;
    t := 0;

    assume(%M:i%);
    
  assume (((_i <= 0) || (j <= 0)) && ((_i <= 0) || (j > -1)) && ((j <= 0) || (_i > -1)) && ((_i > -1) || (j > -1))); // CondTerm
    while (_i != 0 && j != 0) 
    invariant b0(_i, j,i %Inv:i%);
    rec b1(_i, j)
    {
        %assert(i > 0);%
        t := _i;
        _i := j;
        j := t;

        %i := i - 1;%
    }
    
    return ;
}
