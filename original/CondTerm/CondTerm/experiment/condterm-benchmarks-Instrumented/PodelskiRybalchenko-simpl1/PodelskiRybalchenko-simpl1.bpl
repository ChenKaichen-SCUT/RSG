function {:existential true} b0(x:int, y:int, newx:int, newy:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, y:int, if1:int,if2:int,if3:int,newx:int, newy:int): bool;

procedure main()
{
  var x,y,newx,newy,i: int;
  var if1, if2, if3 : int;
  havoc x;
  havoc y;

  if1 := 0;
  if2 := 0;
  if3 := 0;

  assume(%M:i%);

  while (x > 0 && y > 0 && if1 == 0 && if2 == 0 && if3 == 0)
  invariant b0(x,y,newx,newy,i %Inv:i%);
  rec b1(x,y,if1,if2,if3,newx,newy)
  {
    %assert(i > 0);%
    if1 := 0;
    if2 := 0;
    if3 := 0;

    if (*) {

      havoc newx;
      if (newx >= x) { 
        if1 := 1;
        // break; 
      }
      x := newx;

      havoc newy;
      if (newy <= y) { 
        if2 := 1;
        // break; 
      }
      y := newy;

    } else {

      havoc newy;
      if (newy >= y) { 
        if3 := 1;
        // break; 
      }
      y := newy;

    }

    %i := i - 1;%
  }
}
