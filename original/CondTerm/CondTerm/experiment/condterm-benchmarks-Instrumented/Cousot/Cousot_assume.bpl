function {:existential true} b0(t : int, j : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
  var t: int;
  var j, i: int;
  havoc t;
  havoc j;

  assume(%M:i%);

  assume (false); // CondTerm
  while (true)
    invariant b0(t, j,i %Inv:i%);
    rec b1(t, j)
  {
    %assert(i > 0);%
    if (t < j) {
        t := t + 4;
    } else {
        j := j + 1;
        t := t + 2;
    }

    %i := i - 1;%
  }

  return;
}
