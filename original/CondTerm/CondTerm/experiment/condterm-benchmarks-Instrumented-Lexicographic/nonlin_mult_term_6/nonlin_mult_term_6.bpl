function {:existential true} b0(d:int, b:int %FD%): bool;
function {:existential true} b1(d:int, b:int): bool;

procedure main()
{
  var d,b %VD%: int;

  havoc d;
  havoc b;

  %BE%
  	
  while (d * b > 0)
  invariant b0(d,b %IC%);
  rec b1(d,b)
  {
    %BT%
    b := -b;
    
    %IT%
  }
}
