function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y,i: int;

  havoc x;
  havoc y;

  assume(x > y);
  assume(y > 1);
  assume(%M:i%);
  	
  while (x > y)
  invariant b0(x,y,i %Inv:i%);
  rec b1(x,y)
  {
    %assert(i > 0);%
    if(*)
    {
      x := x mod y;
    }
    else
    {
      x := x - y;
    }
    
    %i := i - 1;%
  }
}
