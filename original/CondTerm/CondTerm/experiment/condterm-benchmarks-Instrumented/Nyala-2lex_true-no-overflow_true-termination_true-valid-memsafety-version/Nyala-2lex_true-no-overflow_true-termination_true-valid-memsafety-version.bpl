function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y,i: int;
  havoc x;
  havoc y;

  assume(%M:i%);

  while (x > 0 && y > 0)
  invariant b0(x,y,i %Inv:i%);
  rec b1(x,y)
  {
	%assert(i > 0);%
	y := y - x;
	if (y < 0) {
		x := x - 1;
		havoc y;
	}
	%i := i - 1;%
  }
}
