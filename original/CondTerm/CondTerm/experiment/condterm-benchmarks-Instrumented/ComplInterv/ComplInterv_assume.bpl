function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
  var t, i: int;
  havoc t;

  assume(%M:i%);

  assume ((t <= 3) && (t > -4)); // CondTerm
  while (t * t > 9)
    invariant b0(t,i %Inv:i%);
    rec b1(t)
  {
    %assert(i > 0);%
    if (t < 0) {
        t := t - 1;
    } else {
        t := t + 1;
    }

    %i := i - 1;%
  }

  return;
}
