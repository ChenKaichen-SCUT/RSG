function {:existential true} b0(n : int %FD%): bool;
function {:existential true} b1(n : int): bool;

procedure main()
{
    var n : int;
    var sum %VD%: int;
    havoc n;
    sum := 0;

  %BE%
    
  assume (n > -1); // CondTerm
    while (n != 0) 
        invariant b0(n %IC%);
        rec b1(n)
    {
    %BT%
        sum := sum + n;
        n := n - 1;

    %IT%
    }

    return ;
}
