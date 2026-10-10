function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y,c,i: int;
  havoc x;
  havoc y;
  
  assume(%M:i%);
  
  c := 0;
  while (x + y > 0)
  invariant b0(x,y,i %Inv:i%);
  rec b1(x,y)
  {
    %assert(i > 0);%
    if (x > y){
      x := x - 1;
    }
    else {
      if (x == y){
        x := x - 1;
      }
      else {
        y := y - 1;
      }
    }
    %i := i - 1;%
  }
}
