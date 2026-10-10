function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
  var t, i: int;
  havoc t;

  assume(%M:i%);

  assume (((t <= -16) || (t > -15)) && ((t <= -14) || (t > -13)) && ((t <= -12) || (t > -11)) && ((t <= -10) || (t > -9)) && ((t <= -8) || (t > -7)) && ((t <= -6) || (t > -5)) && ((t <= -4) || (t > -3)) && ((t <= -2) || (t > -1)) && ((t <= 0) || (t > 1)) && ((t <= 2) || (t > 3)) && ((t <= 4) || (t > 5)) && ((t <= 6) || (t > 7)) && ((t <= 8) || (t > 9)) && ((t <= 10) || (t > 11)) && ((t <= 12) || (t > 13)) && ((t <= 14) || (t > 15)) && ((t <= 16) || (t > 17))); // CondTerm
  while (t != 0)
    invariant b0(t,i %Inv:i%);
    rec b1(t)
  {
    %assert(i > 0);%
    if (t < 0) {
        t := t + 2;
           if (t < 0) {
        t := t * (-1);
           }
    } else {
        t := t - 2;
        if (t > 0) {
            t := t * (-1);
        }
    }

    %i := i - 1;%
  }

  return;
}
