function {:existential true} b0(x:int, y:int, N:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, N:int, y:int): bool;

procedure main()
{
  var x,y,N,i: int;
  havoc x;
  havoc y;
  havoc N;
  
  assume(N < 536870912 && x < 536870912 && y < 536870912 && x >= -1073741824);
  assume(x + y >= 0);
  assume(%M:i%);
  
  while (x <= N)
  invariant b0(x,y,N,i %Inv:i%);
  rec b1(x,N,y)
  {
    %assert(i > 0);%

    if (*){
      x := 2 * x + y;
      y := y + 1;
    }
    else {
      x := x + 1;
    }
    %i := i - 1;%
  }
}
