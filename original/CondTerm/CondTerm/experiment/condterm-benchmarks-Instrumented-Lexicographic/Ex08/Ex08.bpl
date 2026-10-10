function {:existential true} b0(t : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{

    var t : int;
    var up %VD%, TR1, TR2, TR3, TR4: int;
    havoc t;
    up := 0;

    %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;
    
    while (t > 0) 
    invariant b0(t %IC%, TR1, TR2, TR3, TR4);
    rec b1(t)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
	TR4 := 0;
        if (t == 1) {
            TR1 := 1;
            up := 1;
        }
        if (t == 10) {
            TR2 := 1;
            up := 0;
        }
        if (up == 1) {
            TR3 := 1;
            t := t+1;
        } else {
            TR4 := 1;
            t := t-1;
        }

	%IT%
    }
    
    return ;
}
