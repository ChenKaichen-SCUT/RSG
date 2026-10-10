function {:existential true} b0(_r:int, da:int, db:int, temp:int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(da:int, _r:int, db:int, temp:int): bool;

procedure main()
{
  var _r,da,db,temp %VD%, TR1, TR2: int;
  havoc _r;

  assume(_r >= 0);
  %BE%
TR1 := 0;
TR2 := 0;

  da := 2 * _r;
  db := 2 * _r;

  while (da >= _r)
  invariant b0(_r,da,db,temp %IC%, TR1, TR2);
  rec b1(da,_r,db,temp)
  {
	%BT%
TR1 := 0;
TR2 := 0;
	if (*) {
TR1 := 1;
		da := da - 1;
	} else {
TR2 := 1;
		da := db - 1;
		db := da;
	}
	%IT%
  }
}
