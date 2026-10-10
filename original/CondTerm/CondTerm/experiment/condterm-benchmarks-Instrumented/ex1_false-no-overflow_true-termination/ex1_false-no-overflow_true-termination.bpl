function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(y:int, x:int): bool;

procedure main()
{
  var x,y,i,r: int;
  havoc x;
  havoc y;

  r := 1;
  
  assume(%M:i%);
  	
  while (y > 0)
  invariant b0(x,y,i %Inv:i%);
  rec b1(y,x)
  {
    %assert(i > 0);%
    r := r * x;
    y := y - 1;

    %i := i - 1;%
  }
}
