function {:existential true} b0(d:int, b:int, i:int %Decl:i%): bool;
function {:existential true} b1(d:int, b:int): bool;

procedure main()
{
  var d,b,i: int;

  havoc d;
  havoc b;

  assume(%M:i%);
  	
  while (d * b > 0)
  invariant b0(d,b,i %Inv:i%);
  rec b1(d,b)
  {
    %assert(i > 0);%
    b := -b;
    
    %i := i - 1;%
  }
}
