function {:existential true} b0(_i:int, x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b0(x:int, y:int, _i:int): bool;

procedure main()
{
  var _i,x,y,i: int;

  _i := 0;
  havoc x;
  havoc y;
  
  assume(x != 0);
  assume(%M:i%);
  	
  while (x > 0 && y > 0)
  invariant b0(_i,x,y,i %Inv:i%);
  rec b1(x,y,_i)
  {
    %assert(i > 0);%
    _i := _i + 1;
    x := (x - 1) - (y - 1);

    %i := i - 1;%
  }
}
