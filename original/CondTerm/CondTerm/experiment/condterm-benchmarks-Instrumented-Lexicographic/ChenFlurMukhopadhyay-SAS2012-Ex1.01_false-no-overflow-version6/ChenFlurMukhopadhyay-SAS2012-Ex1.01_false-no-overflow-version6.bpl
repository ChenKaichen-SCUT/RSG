function {:existential true} b0(x:int, y:int %FD%): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%: int;
  havoc x;
  havoc y;

  %BE%

  while (x + y > 0)
  invariant b0(x,y %IC%);
  rec b1(x,y)
  {
    %BT%
    x := -5*x + 18;
    y := -6*y + 13;
    %IT%
  }
}
