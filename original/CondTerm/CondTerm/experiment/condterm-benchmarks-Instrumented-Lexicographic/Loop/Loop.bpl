function {:existential true} b0(t : int %FD%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var t %VD%: int;
    a := 5;
    b := 3;
    t := 0;

  %BE%
    
    while (t < 10)
    invariant b0(t %IC%);
    rec b1(t)
    { 
    %BT%
        t := t + 0; 

    %IT%
    }
    
    return ;
}
