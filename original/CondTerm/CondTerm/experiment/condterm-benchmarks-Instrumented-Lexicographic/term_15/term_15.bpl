function {:existential true} b0(x:int, y:int %FD%, ATTM$x_DIV_50:int): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%: int;
  havoc x;
  havoc y;

  %BE%

  while (x div 50 == y)
  invariant b0(x,y %IC%, x div 50);
  rec b1(x,y)
  {
    %BT%
    x := x + 51;
    y := y + 1;
    %IT%
  }
}
