function {:existential true} b0(x:int, y:int, z:int, tx:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int, tx:int, z:int): bool;

procedure main()
{
  var x,y,z,tx,i: int;
  havoc x;
  havoc y;
  havoc z;
  havoc tx;

  assume(-1073741823<=tx && tx<=1073741823);
  assume(-1073741823<=z && z<=1073741823);
  assume(-1073741823<=x && x<=1073741823);
  assume(y<=1073741823);

  assume(%M:i%);
  	
  while (x >= y && x <= tx + z)
  invariant b0(x,y,z,tx,i %Inv:i%);
  rec b1(x,y,tx,z)
  {
    %assert(i > 0);%
    if (*)
    {
      z := z - 1;
      tx := x;
      havoc x;
      assume(-1073741823<=x && x<=1073741823);
    }
    else
    {
      y := y + 1;
    }
    %i := i - 1;%
  }
}
