function {:existential true} b0(j:int, d:int %FD%): bool;
function {:existential true} b1(j:int, d:int): bool;

procedure main()
{
  var j,d %VD%: int;

  havoc j;
  havoc d;

  assume(j > d);
  assume(d > 1);

  %BE%
  	
  while (j > d)
  invariant b0(j,d %IC%);
  rec b1(j,d)
  {
    %BT%
    j := j mod 2;

    %IT%
  }
}
