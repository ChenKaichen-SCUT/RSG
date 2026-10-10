function {:existential true} b0(bob : int, samantha : int %FD%): bool;
function {:existential true} b1(bob : int, samantha : int): bool;

procedure main()
{
    var bob : int;
    var samantha : int;
    var temp %VD%: int;
    bob := 13;
    samantha := 17;

  %BE%
    
  assume (bob + samantha > 30); // CondTerm
    while (bob + samantha < 100) 
    invariant b0(bob, samantha %IC%);
    rec b1(bob, samantha)
    {
    %BT%
        temp := bob;
        bob := samantha;
        samantha := temp;

    %IT%
    }
    
    return ;
}
