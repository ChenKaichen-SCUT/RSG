function {:existential true} b0(x:int, y:int %FD%, TR1:int, TR2:int, ATTM$x$SUB$y:int, ATTM$y$SUB$x:int): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%, TR1, TR2: int;
  havoc x;
  havoc y;
  
  assume(x >= 0 && y >= 0);
  %BE%
TR1 := 0;
TR2 := 0;
  	
  while (x - y > 2 || y - x > 2)
  invariant b0(x,y %IC%, TR1, TR2, x-y, y-x);
  rec b1(x,y)
  {
    %BT%
TR1 := 0;
TR2 := 0;
    if(x < y){
TR1 := 1;
      x := x + 1;
    }
    else {
TR2 := 1;
      y := y + 1;
    }
    %IT%
  }
}
