function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
  var t, i: int;
  havoc t;

  assume(%M:i%);

  assume(t == 0);
  while (t != 0)
  {
    if (t < 0) {
        t := t - 1;
        t := t * (-1);
    } else {
        t := t + 1;
        t := t * (-1);
    }
  }
}
