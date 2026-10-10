function {:existential true} b0(_i:int, j:int %FD%, ATTM$_i$SUB$i:int, ATTM$j$ADD$i:int): bool;
function {:existential true} b1(_i:int, j:int): bool;

procedure main()
{
  var _i, j %VD%: int;
  j := 1;
  _i := 10000;
  
  %BE%
  	
  while (_i - j >= 1)
  invariant b0(_i, j %IC%, _i-i, j+i);
  rec b1(_i,j)
  {
    %BT%
    j := j + 1;
    _i := _i - 1;

    %IT%
  }
}
