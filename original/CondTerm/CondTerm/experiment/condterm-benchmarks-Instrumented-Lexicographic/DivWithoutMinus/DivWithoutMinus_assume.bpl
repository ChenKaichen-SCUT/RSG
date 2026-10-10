function {:existential true} b0(x : int, y : int, z : int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(x : int, y : int, z : int): bool;

procedure main()
{
    var x : int;
    var y : int;
    var z %VD%, TR1, TR2: int;
    var res : int;

    havoc x;
    havoc y;
    z := y;
    res := 0;

    %BE%
  TR1 := 0;
  TR2 := 0;

  assume ((x <= 0) || (y <= -1) || ((z <= 0) && (z <= 1))); // CondTerm
    while ((0 == y || (y > 0 && x > 0)) && z > 0)
        invariant b0(x,y,z %IC%, TR1, TR2);
        rec b1(x, y, z)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
        if (y == 0) {
            TR1 := 1;
            res := res + 1;
            y := z;
        }
        else {
            TR2 := 1;
            x := x + 1;
            y := y - 1;
        }

        %IT%
    }
    return;
}

