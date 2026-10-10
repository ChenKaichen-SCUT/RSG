function {:existential true} b0(j:int, b:int, i:int %Decl:i%): bool;
function {:existential true} b1(j:int, b:int): bool;

procedure main()
{
  var j,b,i: int;

  havoc j;
  havoc b;

  assume(b > 1);
  assume(%M:i%);
  	
  while (j < 100)
  invariant b0(j,b,i %Inv:i%);
  rec b1(j,b)
  {
    %assert(i > 0);%
    if (j <= 0)
    {
      j := 1;
    }
    else
    {
      j := j * b;
    }
    
    %i := i - 1;%
  }
}
