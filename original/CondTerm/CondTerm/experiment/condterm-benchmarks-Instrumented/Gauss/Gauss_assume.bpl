function {:existential true} b0(n : int, i:int %Decl:i%): bool;
function {:existential true} b1(n : int): bool;

procedure main()
{
    var n : int;
    var sum, i : int;
    havoc n;
    sum := 0;

    assume(%M:i%);
    
  assume (n > -1); // CondTerm
    while (n != 0) 
        invariant b0(n,i %Inv:i%);
        rec b1(n)
    {
        %assert(i > 0);%
        sum := sum + n;
        n := n - 1;

        %i := i - 1;%
    }

    return ;
}
