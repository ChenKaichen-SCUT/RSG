function {:existential true} b0(x:int, y:int %FD%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%: int;

  havoc x;
  havoc y;
  
  assume(2*y >= 1);
  %BE%
  	
  while (x >= 0)
  invariant b0(x,y %IC%);
  rec b1(x,y)
  {
    %BT%
    x := x - 2 * y + 1;

    %IT%
  }
}
