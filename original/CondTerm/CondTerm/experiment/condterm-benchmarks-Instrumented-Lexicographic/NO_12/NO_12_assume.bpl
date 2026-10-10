function {:existential true} b0(t : int, j : int %FD%, TR1:int): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j %VD%, TR1: int;
    j := 0;
    t := 0;

    %BE%
  TR1 := 0;
    
  assume (j < t); // CondTerm
    while (t <= j) 
    invariant b0(t, j %IC%, TR1);
    rec b1(t, j)
    {
        %BT%
	TR1 := 0;
        if (j-t < 1) { 
            TR1 := 1;
            j := j+2; 
        }
        t := t+1;

	%IT%
    }
    
    return ;
}
