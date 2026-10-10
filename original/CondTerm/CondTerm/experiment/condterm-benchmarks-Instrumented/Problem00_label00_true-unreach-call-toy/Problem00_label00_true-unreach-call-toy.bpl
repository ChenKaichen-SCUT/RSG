function {:existential true} b0(a7:int, outpu:int, inpu:int, i:int %Decl:i%): bool;
function {:existential true} b1(outpu:int, a7:int, inpu:int): bool;

procedure main()
{
  var a7,outpu,inpu,i: int;
  a7 := 0;
  outpu := -1;

  assume(%M:i%);

  while (outpu != 0)
  invariant b0(a7,outpu,inpu,i %Inv:i%);
  rec b1(outpu,a7,inpu)
  {
    %assert(i > 0);%
    havoc inpu;
    // assume ((inpu == 1) || (inpu == 2) || (inpu == 3) || (inpu == 4) || (inpu == 5) || (inpu == 6));
    a7 := a7 + 1;
    if (a7 == 10) { outpu := 0; } else { outpu := inpu - 1; }
    %i := i - 1;%
  }
}
