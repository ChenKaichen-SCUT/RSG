/*
 * termination condition: y < 0;
 */

function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;

procedure main()
{
  var x, y, i: int;
  havoc x;
  havoc y;
  
  assume(%M:i%);

  while (x >= 0)
  invariant b0(x, y, i %Inv:i%);
  rec b0(x, y)
  {
    x := x + y;
  }
}
