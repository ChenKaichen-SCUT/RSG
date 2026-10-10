function {:existential true} b0(x:int, y:int %FD%, ATTM$x_MOD_y:int): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%: int;
  havoc x;
  havoc y;

  assume(!(x <= 0));
  assume(!(y <= 0));
  assume(!(x mod y != 0));
  %BE%

  while (x != 0)
  invariant b0(x,y %IC%, x mod y);
  rec b1(x,y)
  {
    %BT%
    x := x - y;
    %IT%
  }
}
