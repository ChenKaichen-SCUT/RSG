function {:existential true} b0(x:int, y:int %FD%, TR1:int): bool;
function {:existential true} b1(x:int, y:int): bool;

procedure main()
{
  var x,y %VD%, TR1: int;
  havoc x;
  havoc y;

  assume(!(x < y));
  %BE%
TR1 := 0;

  while (x != y)
  invariant b0(x,y %IC%, TR1);
  rec b1(x,y)
  {
    %BT%
TR1 := 0;
    x := x - 1;
    y := y + 1;
    if (x < y) {
TR1 := 1; x := x + 15; }
    %IT%
  }
}
