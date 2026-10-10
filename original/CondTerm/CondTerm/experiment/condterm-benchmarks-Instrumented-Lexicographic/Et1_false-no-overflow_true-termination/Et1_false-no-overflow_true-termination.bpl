function {:existential true} b0(a:int, b:int %FD%): bool;
function {:existential true} b1(a:int, b:int): bool;

procedure main()
{
  var a, b %VD%: int;
  havoc a;
  havoc b;
  
  %BE%
  	
  while (a > b)
  invariant b0(a, b %IC%);
  rec b1(a,b)
  {
    %BT%
    b := b + a;
    a := a + 1;

    %IT%
  }
}
