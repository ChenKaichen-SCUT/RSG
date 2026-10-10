function {:existential true} b0(t : int %FD%, TR1:int, TR2:int, TR3:int): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t %VD%, TR1, TR2, TR3: int;
    havoc t;

    %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
    
    while (t > 0 && t < 50) 
    invariant b0(t %IC%, TR1, TR2, TR3);
    rec b1(t)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
        if (t < 20) {
            TR1 := 1;
            t := t-1;
        }
        if (t > 10) {
            TR2 := 1;
            t := t+1;
        }
        if (30 <= t && t <= 40) {
            TR3 := 1;
            t := t-1;
        }
        
	%IT%
    }
    
    return;
}
