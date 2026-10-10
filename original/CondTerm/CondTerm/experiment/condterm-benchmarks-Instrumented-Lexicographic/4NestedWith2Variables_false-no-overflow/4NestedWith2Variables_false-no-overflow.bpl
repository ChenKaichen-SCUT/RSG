function {:existential true} b0(a:int, b:int, olda:int %FD% ): bool;
function {:existential true} b1(a:int, b:int, olda:int): bool;


procedure main()
{
  var a,b,olda %VD%: int;
  havoc a;
  havoc b;

  %BE%
  	
  while (a > 0)
  invariant b0(a,b,olda %IC%);
  rec b1(a,b,olda)
  {
    %BT%
    olda := a;
    a := 3*olda - 4*b;
    b := 4*olda + 3*b;
    %IT%
  }
}
