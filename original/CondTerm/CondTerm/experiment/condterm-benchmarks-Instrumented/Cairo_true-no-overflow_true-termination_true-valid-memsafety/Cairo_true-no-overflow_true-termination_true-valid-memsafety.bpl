function {:existential true} b0(x:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int): bool;

procedure main()
{
  var x,i: int;
  havoc x;
  
  assume(x > 0);
  assume(%M:i%);
  
  while (x != 0)
  invariant b0(x,i %Inv:i%);
  rec b1(x)
  {
    %assert(i > 0);%
    x := x - 1;
    %i := i - 1;%
  }
}
