function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y,i: int;
  havoc x;
  havoc y;

  assume(y <= 0);
  assume(%M:i%);
  	
  while (x != 0)
  invariant b0(x,y,i %Inv:i%);
  rec b1(x,y)
  {
    %assert(i > 0);%

    if(x < 10){
      x := x + 1;
    }
    else {
      x := -1;
    }
    %i := i - 1;%
  }
}
