function {:existential true} b0(x:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int): bool;

procedure main()
{
  var x,i: int;
  havoc x;

  assume(%M:i%);

  while (x < 0)
  invariant b0(x,i %Inv:i%);
  rec b1(x)
  {
    %assert(i > 0);%
    x := -3*x - 17;
    %i := i - 1;%
  }
}
