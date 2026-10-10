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
    
    while (_i > 0 && j > 0) 
    invariant b0(_i, j,i %Inv:i%);
    rec b1(_i, j)
    {
        %assert(i > 0);%
        if (_i < j) {
            t := _i;
            _i := j;
            j := t;
        } else {
            if (_i > j) {
                j := _i;
            } else {
                _i := _i-1;
            }
        }

        %i := i - 1;%
    }
    
    return ;
}
