function {:existential true} b0(t : int, w: int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, w: int): bool;

procedure main()
{
  var t: int;
  var w, i : int;
  havoc t;

  assume(%M:i%);

  assume (((t > -1) || (w != 0)) && ((t < 1) || (w != 0)) && ((w > 1) || (t + w < 3)) && ((w > 1) || (t - w > -3))); // CondTerm
  while (t != 0)
    invariant b0(t, w,i %Inv:i%);
    rec b1(t, w)
  {
    %assert(i > 0);%
    if (t < -1 * w) {
        t := t - 1;
        t := t * (-1);
    } else {
        if (t > w) {
            t := t + 1;
            t := t * (-1);
        } else {
            t := 0;
        }
    }

    %i := i - 1;%
  }

  return;
}
