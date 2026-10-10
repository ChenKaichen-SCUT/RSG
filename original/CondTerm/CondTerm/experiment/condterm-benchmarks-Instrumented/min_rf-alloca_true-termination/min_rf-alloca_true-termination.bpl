function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(y:int, x:int): bool;

procedure main()
{
  var x,y,z,i: int;

  havoc x;
  havoc y;

  assume(%M:i%);
  	
  while (y > 0 && x > 0)
  invariant b0(x,y,i %Inv:i%);
  rec b1(y,x)
  {
    %assert(i > 0);%
    if (x > y)
    {
        z := y;
    }
    else
    {
        z := x;
    }
    if (*)
    {
        y := y + x;
        x := z - 1;
        z := y + z;
    }
    else
    {
        y := y + x;
        x := z - 1;
        z := x + z;
    }
    
    %i := i - 1;%
  }
}
