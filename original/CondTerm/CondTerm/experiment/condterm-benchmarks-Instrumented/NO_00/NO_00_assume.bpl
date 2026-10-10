function {:existential true} b0(x:int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int): bool;

procedure main()
{
  var x,i: int;

  havoc x;

  assume(%M:i%);
  	
  assume ((x > 0) && (x > 1) && (x > 2) && (x > 3) && (x > 4) && (x > 5) && (x > 6) && (x > 7) && (x > 8) && (x > 9) && (x > 10) && (x > 11) && (x > 12) && (x > 13) && (x > 14)); // CondTerm
  while (x < 100)
  invariant b0(x,i %Inv:i%);
  rec b1(x)
  {
    %assert(i > 0);%
    x := x + 0;

    %i := i - 1;%
  }
}
