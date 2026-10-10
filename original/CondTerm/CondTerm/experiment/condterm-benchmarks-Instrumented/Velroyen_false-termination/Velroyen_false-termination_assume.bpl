/*
 * Terminating Program for x < -5 OR 0 <= x <= 30 OR x > 35
 * (from benchmarks of) 2008TAP - Velroyen,Rummer - Non-Termination Checking for Imperative Programs
 *
 * Date: 18.12.2013
 * Author: urban@di.ens.fr
 */
function {:existential true} b0(x : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int): bool;

procedure main()
{
  var x, i: int;

  assume(%M:i%);

  assume (((x <= -6) && (x <= 30)) || ((x <= -6) && (x > 35)) || ((x <= 30) && (x > -1)) || ((x > -1) && (x > 35))); // CondTerm
  while (x != 0)
    invariant b0(x,i %Inv:i%);
    rec b1(x)
  {
    %assert(i > 0);%
    if (-5 <= x && x <= 35) {
        if (x < 0) {
            x := -5;
        } else {
            if (x > 30) {
                x := 35;
            } else {
                x := x - 1;
            }
        }
    } else {
        x := 0;
    }
    %i := i - 1;%
  }
}
