function {:existential true} b0(j:int, d:int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(j:int, d:int): bool;

procedure main()
{
  var j,d %VD%, TR1, TR2: int;

  havoc j;
  havoc d;

  %BE%
TR1 := 0;
TR2 := 0;
  	
  while (j > 0 && d > 0)
  invariant b0(j,d %IC%, TR1, TR2);
  rec b1(j,d)
  {
    %BT%
TR1 := 0;
TR2 := 0;
    if(*)
    {
TR1 := 1;
      j := j - 1;
    }
    else
    {
TR2 := 1;
      d := d - 1;
    }
    
    %IT%
  }
}
