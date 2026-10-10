function {:existential true} b0(x:int, y:int, z:int, w:int, c:int %FD%, TR1:int): bool;
function {:existential true} b1(w:int, x:int, y:int, z:int, c:int): bool;

procedure main()
{
  var x,y,z,w,c %VD%, TR1: int;
  havoc x;
  havoc y;
  havoc z;
  w := x + y + z;
  c := 0;

  %BE%
TR1 := 0;

  while (w == x + y + z)
  invariant b0(x,y,z,w,c %IC%, TR1);
  rec b1(w,x,y,z,c)
  {
    %BT%
TR1 := 0;
    if (c < 100) {
TR1 := 1; y := y - 1; }
    c := c + 1;
    x := x + y + c;
    z := z - y;
    %IT%
  }
}
