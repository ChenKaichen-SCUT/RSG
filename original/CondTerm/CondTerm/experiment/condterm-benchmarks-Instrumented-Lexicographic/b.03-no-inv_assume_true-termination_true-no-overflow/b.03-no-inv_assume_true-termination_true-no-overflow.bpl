function {:existential true} b0(x:int, y:int %FD%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%: int;
  havoc x;
  havoc y;
  
  assume(x > 0);
  %BE%
  
  while (x > y && y <= 2147483647 - x)
  invariant b0(x,y %IC%);
  rec b1(x,y)
  {
    %BT%
    
    y := y + x;
    %IT%
  }
}
