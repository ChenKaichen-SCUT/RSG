function {:existential true} b0(_i:int,j:int,k:int,tmp:int %FD%): bool;
function {:existential true} b1(_i:int,j:int,k:int,tmp:int): bool;

procedure main()
{
  var c,_i,j,k,tmp %VD%: int;
  havoc _i;
  havoc j;
  havoc k;
  havoc tmp;
  
  %BE%
  
  while (_i <= 100)
  invariant b0(_i,j,k,tmp %IC%);
  rec b1(_i,j,k,tmp)
  {
    %BT%
    
    tmp := _i;
    _i := j;
    j := tmp + 1;
    %IT%
  }
}
