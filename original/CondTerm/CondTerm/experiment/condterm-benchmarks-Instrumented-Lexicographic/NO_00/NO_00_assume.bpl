function {:existential true} b0(x:int %FD%): bool;
function {:existential true} b1(x : int): bool;

procedure main()
{
  var x %VD%: int;

  havoc x;

  %BE%
  	
  assume ((x > 0) && (x > 1) && (x > 2) && (x > 3) && (x > 4) && (x > 5) && (x > 6) && (x > 7) && (x > 8) && (x > 9) && (x > 10) && (x > 11) && (x > 12) && (x > 13) && (x > 14)); // CondTerm
  while (x < 100)
  invariant b0(x %IC%);
  rec b1(x)
  {
    %BT%
    x := x + 0;

    %IT%
  }
}
