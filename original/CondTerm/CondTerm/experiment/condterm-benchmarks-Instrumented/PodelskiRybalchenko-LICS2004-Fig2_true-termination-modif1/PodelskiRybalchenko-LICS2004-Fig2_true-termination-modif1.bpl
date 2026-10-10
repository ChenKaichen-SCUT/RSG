function {:existential true} b0(x:int, y:int, old_x:int, old_y:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int, old_x:int, old_y:int): bool;

procedure main()
{
  var x,y,old_x,old_y,i: int;

  havoc x;
  havoc y;

  assume(%M:i%);
  	
  while (x > 0 && y > 0)
  invariant b0(x,y,old_x,old_y,i %Inv:i%);
  rec b1(x,y,old_x,old_y)
  {
    %assert(i > 0);%
    old_x := x;
    old_y := y;
    if(*)
    {
        x := old_x - 1;
        y := old_x;
    }
    else
    {
        x := old_x - 3;
        y := old_x + 1;
    }

    %i := i - 1;%
  }
}
