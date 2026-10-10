function {:existential true} b0(a:int, b:int, i:int %Decl:i%): bool;
function {:existential true} b1(a:int, b:int): bool;

procedure main()
{
  var a, b, i: int;
  havoc a;
  havoc b;
  
  assume(%M:i%);
  	
  while (a > b)
  invariant b0(a, b, i %Inv:i%);
  rec b1(a,b)
  {
    %assert(i > 0);%
    b := b + a;
    a := a + 1;

    %i := i - 1;%
  }
}
