function {:existential true} b0(bob : int, samantha : int, i:int %Decl:i%): bool;
function {:existential true} b1(bob : int, samantha : int): bool;

procedure main()
{
    var bob : int;
    var samantha : int;
    var temp, i : int;
    bob := 13;
    samantha := 17;

    assume(%M:i%);
    
    while (bob + samantha < 100) 
    invariant b0(bob, samantha,i %Inv:i%);
    rec b1(bob, samantha)
    {
        %assert(i > 0);%
        temp := bob;
        bob := samantha;
        samantha := temp;

        %i := i - 1;%
    }
    
    return ;
}
