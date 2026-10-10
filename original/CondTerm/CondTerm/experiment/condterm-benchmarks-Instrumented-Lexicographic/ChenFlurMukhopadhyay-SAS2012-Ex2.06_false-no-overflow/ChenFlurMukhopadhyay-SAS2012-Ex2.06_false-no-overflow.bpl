function {:existential true} b0(x:int, y:int, oldx:int %FD%): bool;
function {:existential true} b1(x:int, y:int, oldx:int): bool;

procedure main()
{
  var x,y,oldx %VD%: int;
  havoc x;
  havoc y;

  %BE%

  while (4*x + y > 0)
  invariant b0(x,y,oldx %IC%);
  rec b1(x,y,oldx)
  {
    %BT%
    oldx := x;
    x := -2*oldx + 4*y;
    y := 4*oldx;
    %IT%
  }
}
