function {:existential true} b0(x:int, y:int %FD%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%: int;

  havoc y;
  
  x := y + 42;

  %BE%
  	
  while (x >= 0)
  invariant b0(x,y %IC%);
  rec b1(x,y)
  {
    %BT%
    y := 2 * y - x;
    x := (y + x) div 2;

    %IT%
  }
}
