function {:existential true} b0(x:int, y:int, n:int %FD%): bool;
function {:existential true} b1(x:int, y:int, n:int): bool;

procedure main()
{
  var x,y,n %VD%: int;
  havoc x;
  havoc y;
  havoc n;
  
  %BE%
  	
  while (x + y >= 0 && x <= n)
  invariant b0(x,y,n %IC%);
  rec b1(x,y,n)
  {
    %BT%
    x := 2 * x + y;
    y := y + 1;
    
    %IT%
  }
}
