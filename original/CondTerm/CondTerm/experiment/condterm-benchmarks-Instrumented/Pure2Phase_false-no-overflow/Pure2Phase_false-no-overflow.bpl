function {:existential true} b0(y:int, z:int, i:int %Decl:i%): bool;
function {:existential true} b1(z:int, y:int): bool;

procedure main()
{
  var y,z,i: int;
  havoc y;
  havoc z;

  assume(%M:i%);

  while (z >= 0)
  invariant b0(y,z,i %Inv:i%);
  rec b1(z,y)
  {
	%assert(i > 0);%
	y := y - 1;
	if (y >= 0) {
		havoc z;
	} else {
		z := z - 1;
	}
	%i := i - 1;%
  }
}
