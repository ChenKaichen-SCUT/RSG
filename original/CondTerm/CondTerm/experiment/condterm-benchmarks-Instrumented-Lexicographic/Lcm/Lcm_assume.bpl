function {:existential true} b0(am : int, bm : int, a : int, b : int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(am : int, bm : int, a : int, b : int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var am : int;
    var bm %VD%, TR1, TR2: int;
    am := a;
    bm := b;

    %BE%
  TR1 := 0;
  TR2 := 0;

  assume (((am <= bm) && (a > 0)) || ((a > 0) && (b > 0)) || ((am <= bm) && (am - bm > -1)) || ((b > 0) && (am - bm > -1))); // CondTerm
    while (am != bm) 
    invariant b0(am, bm, a, b %IC%, TR1, TR2);
    rec b1(am, bm, a, b)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
        if (am > bm) {
            TR1 := 1;
            bm := bm+b;
        } else {
            TR2 := 1;
            am := am+a;
        }

	%IT%
    }

    return ;
}
