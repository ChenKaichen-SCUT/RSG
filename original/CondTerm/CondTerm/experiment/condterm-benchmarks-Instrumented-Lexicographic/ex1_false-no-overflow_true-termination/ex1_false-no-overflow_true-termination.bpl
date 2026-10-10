function {:existential true} b0(x:int, y:int %FD%): bool;
function {:existential true} b1(y:int, x:int): bool;

procedure main()
{
  var x,y %VD%,r: int;
  havoc x;
  havoc y;

  r := 1;
  
  %BE%
  	
  while (y > 0)
  invariant b0(x,y %IC%);
  rec b1(y,x)
  {
    %BT%
    r := r * x;
    y := y - 1;

    %IT%
  }
}
