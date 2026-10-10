function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y,i: int;
  x := -2;
  y := 1;

  assume(%M:i%);

  assume (true); // CondTerm
  while (x > 0)
  invariant b0(x,y,i %Inv:i%);
  rec b1(x,y)
  {
    %assert(i > 0);%
    x := x + y;
    y := y + 1;
    %i := i - 1;%
  }
}
