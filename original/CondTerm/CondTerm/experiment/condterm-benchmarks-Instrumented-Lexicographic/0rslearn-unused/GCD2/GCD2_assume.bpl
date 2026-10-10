function {:existential true} b0(x : int, y : int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main()
{
    var x : int;
    var y : int;
    var tmp : int;
    var xtmp %VD%, TR1, TR2: int;
    havoc x;
    havoc y;

    %BE%
  TR1 := 0;
  TR2 := 0;

  assume ((x > y) || ((x <= 0) && (y <= 1)) || ((y <= 0) && (y <= 1)) || ((y > 1) && (x - y <= -1))); // CondTerm
    while((y != 0 && x >= 0) && y >= 0) 
    invariant b0(x,y %IC%, TR1, TR2);
    rec b1(x, y)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
        tmp := y;
        xtmp := x;

        if (x == y) {
            TR1 := 1;
            y := 0;
        }
        else {
            TR2 := 1;
            while(xtmp>y) {
                xtmp := xtmp - y;
            }
        }

        y := xtmp;
        x := tmp;

	%IT%
    }

    return;
}
