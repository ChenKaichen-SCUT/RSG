function {:existential true} b0(x:int, oldx:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, oldx:int): bool;

procedure main()
{
  var x,oldx,i: int;
  havoc x;
  
  assume(%M:i%);
  	
  while (x > 0 && x < 100 && x >= 2 * oldx + 10)
  invariant b0(x,oldx,i %Inv:i%);
  rec b1(x,oldx)
  {
    %assert(i > 0);%
    oldx := x;
    havoc x;
    
    %i := i - 1;%
  }
}
