function {:existential true} b0(x:int, y:int, newx:int, newy:int %FD%, TR1:int, TR2:int, TR3:int, TR4:int, TR5:int): bool;
function {:existential true} b1(x:int, y:int, if1:int,if2:int,if3:int,newx:int, newy:int): bool;

procedure main()
{
  var x,y,newx,newy %VD%, TR1, TR2, TR3, TR4, TR5: int;
  var if1, if2, if3 : int;
  havoc x;
  havoc y;

  if1 := 0;
  if2 := 0;
  if3 := 0;

  %BE%
TR1 := 0;
TR2 := 0;
TR3 := 0;
TR4 := 0;
TR5 := 0;

  while (x > 0 && y > 0 && if1 == 0 && if2 == 0 && if3 == 0)
  invariant b0(x,y,newx,newy %IC%, TR1, TR2, TR3, TR4, TR5);
  rec b1(x,y,if1,if2,if3,newx,newy)
  {
    %BT%
TR1 := 0;
TR2 := 0;
TR3 := 0;
TR4 := 0;
TR5 := 0;

    if1 := 0;
    if2 := 0;
    if3 := 0;

    if (*) {
TR1 := 1;

      havoc newx;
      if (newx >= x) {
        TR2 := 1; 
        if1 := 1;
        // break; 
      }
      x := newx;

      havoc newy;
      if (newy <= y) {
        TR3 := 1; 
        if2 := 1;
        // break; 
      }
      y := newy;

    } else {
TR4 := 1;

      havoc newy;
      if (newy >= y) {
        TR5 := 1; 
        if3 := 1;
        // break; 
      }
      y := newy;

    }

    %IT%
  }
}
