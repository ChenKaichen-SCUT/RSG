function {:existential true} b0(a:int, b:int, i:int %Decl:i%): bool;
function {:existential true} b1(a:int, b:int): bool;

procedure main()
{
  var a,b,i: int;
  havoc a;
  havoc b;

  assume(%M:i%);

  while (a >= 0)
  invariant b0(a,b,i %Inv:i%);
  rec b1(a,b)
  {
	%assert(i > 0);%
	a := a + b;
	if (b >= 0) {
		b := -b - 1;
	} else {
		b := -b;
	}
	%i := i - 1;%
  }
}
