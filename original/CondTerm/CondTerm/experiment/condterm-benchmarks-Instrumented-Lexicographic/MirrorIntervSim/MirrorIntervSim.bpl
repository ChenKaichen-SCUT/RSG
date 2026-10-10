function {:existential true} b0(t : int %FD%, TR1:int, TR2:int, TR3:int, TR4:int, TR5:int, TR6:int): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t %VD%, TR1, TR2, TR3, TR4, TR5, TR6: int;
    havoc t;

    %BE%
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  TR4 := 0;
  TR5 := 0; 
  TR6 := 0;
    
    while (t != 0) 
    invariant b0(t %IC%, TR1, TR2, TR3, TR4, TR5, TR6);
    rec b1(t)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
	TR3 := 0;
	TR4 := 0;
	TR5 := 0;
	TR6 := 0;
        if (-5 <= t && t <= 35) {
            TR1 := 1;
            if (t < 0) {
                TR2 := 1;
                t := -5;
            } else {
                TR3 := 1;
                if (t > 30) {
                    TR4 := 1;
                    t := 35;
                } else {
                    TR5 := 1;
                    t := t-1;
                }	
            }					
        } else {
            TR6 := 1;
            t := 0;
        }

	%IT%
    }
    
    return ;
}
