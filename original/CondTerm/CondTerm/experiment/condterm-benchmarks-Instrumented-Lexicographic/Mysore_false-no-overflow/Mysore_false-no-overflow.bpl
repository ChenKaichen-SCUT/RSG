function {:existential true} b0(c:int, x:int %FD%): bool;
function {:existential true} b1(x:int, c:int): bool;

procedure main()
{
  var c,x %VD%: int;

  havoc c;
  havoc x;

  assume(c >= 2);
  %BE%
  	
  while (x + c >= 0)
  invariant b0(c,x %IC%);
  rec b1(x,c)
  {
    %BT%
    x := x - c;
    c := c + 1;
    
    %IT%
  }
}
