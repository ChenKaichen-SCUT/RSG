function {:existential true} b0(x:int, y:int %FD%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%: int;

  havoc x;
  havoc y;

  assume(x > y);
  %BE%
  	
  while (x != y)
  invariant b0(x,y %IC%);
  rec b1(x,y)
  {
    %BT%
    x := x - 2;
    y := y - 1;

    %IT%
  }
}
