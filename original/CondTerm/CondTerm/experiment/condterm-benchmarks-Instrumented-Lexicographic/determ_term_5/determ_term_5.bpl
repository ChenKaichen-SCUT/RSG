function {:existential true} b0(_i:int, j:int, k:int %FD%): bool;
function {:existential true} b1(_i:int, j:int, k:int): bool;

procedure main()
{
  var _i,j,k %VD%: int;
  _i := -7;
  j := 2;
  k := 8;
  
  %BE%
  	
  while (_i != j)
  invariant b0(_i,j,k %IC%);
  rec b1(_i,j,k)
  {
    %BT%
    _i := _i + j - k;
    j := j * 2;
    k := k - 1;

    %IT%
  }
}
