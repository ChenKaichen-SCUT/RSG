function {:existential true} b0(t : int %FD%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var t %VD%: int;
    havoc t;

  %BE%
    
  assume (t <= 2); // CondTerm
    while (t > 2)
    invariant b0(t %IC%);
    rec b1(t)
    {
    %BT%
        t := t+1;

    %IT%
    }
    
    return ;
}
