function {:existential true} b0(_i:int, j:int, i:int %Decl:i%, ATTM$_i$SUB$2$MUL$i:int, ATTM$j$ADD$3$MUL$i:int): bool;
function {:existential true} b1(_i:int, j:int): bool;

procedure main()
{
  var _i,j,i: int;
  j := 1;
  _i := 10000;

  assume(%M:i%);

  while (_i-j >= 1)
  invariant b0(_i,j,i %Inv:i%, _i-2*i, j+3*i);
  rec b1(_i,j)
  {
    %assert(i > 0);%
    j := j + 3;
    _i := _i - 2;
    %i := i - 1;%
  }
}
