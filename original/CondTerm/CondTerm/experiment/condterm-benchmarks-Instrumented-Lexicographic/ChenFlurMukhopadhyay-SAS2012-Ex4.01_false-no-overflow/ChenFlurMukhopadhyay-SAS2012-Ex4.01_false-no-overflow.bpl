function {:existential true} b0(x:int, y:int, z:int, n:int %FD%): bool;
function {:existential true} b1(x:int, y:int, n:int, z:int): bool;

procedure main()
{
  var x,y,z,n %VD%: int;
  havoc x;
  havoc y;
  havoc z;
  havoc n;

  %BE%

  while (x + y >= 0 && x <= n)
  invariant b0(x,y,z,n %IC%);
  rec b1(x,y,n,z)
  {
    %BT%
    x := 2*x + y;
    y := z;
    z := z + 1;
    %IT%
  }
}
