function {:existential true} b0(x:int, y:int, n:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int, n:int): bool;

procedure main()
{
  var x,y,n,i: int;
  havoc x;
  havoc y;
  havoc n;
  
  assume(%M:i%);
  	
  while (x + y >= 0 && x <= n)
  invariant b0(x,y,n,i %Inv:i%);
  rec b1(x,y,n)
  {
    %assert(i > 0);%
    x := 2 * x + y;
    y := y + 1;
    
    %i := i - 1;%
  }
}
