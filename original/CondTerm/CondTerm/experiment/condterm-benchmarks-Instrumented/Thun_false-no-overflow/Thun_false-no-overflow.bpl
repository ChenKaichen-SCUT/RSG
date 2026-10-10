function {:existential true} b0(x:int, y:int, i:int %Decl:i%, ATTM$2$MUL$x$ADD$y:int): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y,i: int;

  havoc x;
  havoc y;

  assume(%M:i%);
  	
  while (x >= 0)
  invariant b0(x,y,i %Inv:i%, 2*x + y);
  rec b1(x,y)
  {
    %assert(i > 0);%
    x := x + y;
    y := (-2) * y - 1;
    
    %i := i - 1;%
  }
}
