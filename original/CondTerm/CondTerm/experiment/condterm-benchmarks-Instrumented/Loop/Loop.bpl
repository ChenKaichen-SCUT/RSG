function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var t, i : int;
    a := 5;
    b := 3;
    t := 0;

    assume(%M:i%);
    
    while (t < 10)
    invariant b0(t,i %Inv:i%); 
    rec b1(t)
    { 
        %assert(i > 0);%
        t := t + 0; 

        %i := i - 1;%
    }
    
    return ;
}
