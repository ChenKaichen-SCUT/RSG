function {:existential true} b0(x:int, y:int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main()
{
  var x,y,i: int;

  havoc x;
  havoc y;

  assume(%M:i%);
  	
  assume (((x <= -1) || (y <= -2) || (x + y <= -1)) && ((y <= -6) || (y > -5) || (x + y <= 9)) && ((y <= -5) || (y > -4) || (x + y <= 5)) && ((x <= -1) || (y <= -4) || (y > -2) || (x + y <= 2)) && ((x <= -1) || (y <= -5) || (y > -4) || (x <= -y) || (x + y <= 5)) && ((x <= -1) || (y <= -4) || (y > -3) || (x <= -y) || (x + y <= 2)) && ((x <= -1) || (y <= -3) || (y > -2) || (x <= -y) || (x + y <= -1)) && ((x <= -1) || (y <= -3) || (y > -2) || (x <= -y) || (x + y <= -1) || (x + y > 2)) && (((x <= -1) && (x <= 0)) || ((x <= -1) && (y <= -2)) || ((x <= -1) && (x <= -y)) || ((y <= -3) && (y <= -2) && (y <= -1)) || ((x <= 0) && (y <= -1) && (x + y <= -1)) || ((y <= -2) && (y <= -1) && (x <= -y)) || ((y <= -2) && (y <= -1) && (x + y <= -1)) || ((y <= -1) && (x <= -y) && (x + y <= -1)))); // CondTerm
  while (x >= 0)
  invariant b0(x,y,i %Inv:i%);
  rec b1(x, y)
  {
    %assert(i > 0);%
    x := x + y;
    y := y + 1;

    %i := i - 1;%
  }
}
