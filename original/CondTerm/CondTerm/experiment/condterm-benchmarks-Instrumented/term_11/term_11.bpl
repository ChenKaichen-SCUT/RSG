function {:existential true} b0(K:int, x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, K:int, y:int): bool;

procedure main()
{
  var K,x,y,i: int;

  havoc K;
  havoc x;
  havoc y;

  assume(%M:i%);
  	
  while (x != K || y != K)
  invariant b0(K,x,y,i %Inv:i%);
  rec b1(x,K,y)
  {
    %assert(i > 0);%

    if(x > K)
    {
      x := x - 1;
    }
    else if(x < K)
    {
      x := x + 1;
    }
    if(y > K)
    {
      y := y - 1;
    }
    else if(y < K)
    {
      y := y + 1;
    }

    %i := i - 1;%
  }
}
