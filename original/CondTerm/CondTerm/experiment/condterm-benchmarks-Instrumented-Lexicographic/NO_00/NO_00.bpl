function {:existential true} b0(x:int %FD%): bool;
function {:existential true} b1(x : int): bool;

procedure main()
{
  var x %VD%: int;

  havoc x;

  %BE%
  	
  while (x < 100)
  invariant b0(x %IC%);
  rec b1(x)
  {
    %BT%
    x := x + 0;

    %IT%
  }
}
