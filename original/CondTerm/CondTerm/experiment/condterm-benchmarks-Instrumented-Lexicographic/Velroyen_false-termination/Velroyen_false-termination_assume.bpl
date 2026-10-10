/*
 * Terminating Program for x < -5 OR 0 <= x <= 30 OR x > 35
 * (from benchmarks of) 2008TAP - Velroyen,Rummer - Non-Termination Checking for Imperative Programs
 *
 * Date: 18.12.2013
 * Author: urban@di.ens.fr
 */
function {:existential true} b0(x : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int, TR5:int, TR6:int): bool;
function {:existential true} b1(x : int): bool;

procedure main()
{
  var x %VD%, TR1, TR2, TR3, TR4, TR5, TR6: int;

  %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;
  TR5 := 0; 
  TR6 := 0;

  assume (((x <= -6) && (x <= 30)) || ((x <= -6) && (x > 35)) || ((x <= 30) && (x > -1)) || ((x > -1) && (x > 35))); // CondTerm
  while (x != 0)
    invariant b0(x %IC%, TR1, TR2, TR3, TR4, TR5, TR6);
    rec b1(x)
  {
    %BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
	TR4 := 0;
	TR5 := 0;
	TR6 := 0;
    if (-5 <= x && x <= 35) {
      TR1 := 1;
        if (x < 0) {
          TR2 := 1;
            x := -5;
        } else {
          TR3 := 1;
            if (x > 30) {
              TR4 := 1;
                x := 35;
            } else {
              TR5 := 1;
                x := x - 1;
            }
        }
    } else {
      TR6 := 1;
        x := 0;
    }
	%IT%
  }
}
