/*
 * termination condition: y < 0;
 */

function {:existential true} b0(x:int, y:int %FD%): bool;

procedure main()
{
  var x, y %VD%: int;
  havoc x;
  havoc y;
  
  %BE%;

  while (x >= 0)
  invariant b0(x, y %IC%);
  rec b0(x, y)
  {
    %BT%
    x := x + y;
    
    %IT%
  }
}
