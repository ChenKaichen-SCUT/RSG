function {:existential true} b0(t : int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t %VD%, TR1, TR2: int;
    t := 0;

    %BE%
  TR1 := 0;
  TR2 := 0;
    
  assume (t > 51); // CondTerm
    while (t < 100) 
    invariant b0(t %IC%, TR1, TR2);
    rec b1(t)
    {
        %BT%
	TR1 := 0;
	TR2 := 0;
        if (t < 50) { 
            TR1 := 1;
            t := 51;}
        else { 
            TR2 := 1;
            t := 49; }

	%IT%
    }
    
    return;
}
