function {:existential true} b0(t : int, j : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, j : int): bool;

procedure main()
{
    var t : int;
    var j, i : int;
    j := 100;
    t := 0;

    assume(%M:i%);
    
  assume (j - t < 100); // CondTerm
    while (t < j) 
    invariant b0(t, j,i %Inv:i%);
    rec b1(t, j)
    {
        %assert(i > 0);%
        j := j+1;
        t := t+1;

        %i := i - 1;%
    }
    
    return ;
}
