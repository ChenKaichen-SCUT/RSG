function {:existential true} b0(x:int, y:int, z:int, tx:int %FD%): bool;
function {:existential true} b1(x:int, y:int, tx:int, z:int): bool;

procedure main()
{
  var x,y,z,tx %VD%: int;
  havoc x;
  havoc y;
  havoc z;
  havoc tx;

  %BE%
  	
  while (x >= y && x <= tx + z)
  invariant b0(x,y,z,tx %IC%);
  rec b1(x,y,tx,z)
  {
    %BT%
    z := z - 1;
    tx := x;
    havoc x;

    %IT%
  }
}
