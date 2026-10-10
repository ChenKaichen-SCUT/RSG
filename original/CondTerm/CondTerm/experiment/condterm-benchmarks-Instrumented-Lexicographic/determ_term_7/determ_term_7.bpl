function {:existential true} b0(a:int, b:int, c:int, d:int, _e:int %FD%): bool;
function {:existential true} b1(a:int, b:int, c:int, d:int, _e:int): bool;

procedure main()
{
  var a, b, c, d, _e %VD%: int;
  a := 0;
  b := 0;
  c := 0;
  d := 0;
  _e := 0;
  
  %BE%
  	
  while (a == 0)
  invariant b0(a, b, c, d, _e %IC%);
  rec b1(a, b, c, d, _e)
  {
    %BT%
    a := a + b;
    b := b + c;
    c := c + d;
    d := d + _e;
    _e := _e + 1;

    %IT%
  }
}
