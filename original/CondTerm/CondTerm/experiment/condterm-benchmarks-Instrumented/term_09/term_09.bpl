function {:existential true} b0(K:int, x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(y:int, K:int, x:int): bool;

procedure main()
{
  var K,x,y,i: int;
  havoc K;
  havoc x;
  havoc y;

  assume(x < y);
  assume(%M:i%);

  while (y != K)
  invariant b0(K,x,y,i %Inv:i%);
  rec b1(y,K,x)
  {
    %assert(i > 0);%
    if (x == y) {
      if (x > K) {
        x := x - 1;
      } else {
        x := x + 1;
      }
      y := x;
    } else {
      y := y - 1;
    }
    %i := i - 1;%
  }
}
