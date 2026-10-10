function {:existential true} b0(x:int, y:int, i:int %Decl:i%, ATTM$x_DIV_50:int): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y,i: int;
  havoc x;
  havoc y;

  assume(%M:i%);

  while (x div 50 == y)
  invariant b0(x,y,i %Inv:i%, x div 50);
  rec b1(x,y)
  {
    %assert(i > 0);%
    x := x + 51;
    y := y + 1;
    %i := i - 1;%
  }
}
