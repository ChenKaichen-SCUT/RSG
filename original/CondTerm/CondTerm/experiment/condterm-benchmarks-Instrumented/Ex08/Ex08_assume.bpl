function {:existential true} b0(t : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main()
{

    var t : int;
    var up, i : int;
    havoc t;
    up := 0;

    assume(%M:i%);
    
  assume (t <= 0); // CondTerm
    while (t > 0) 
    invariant b0(t,i %Inv:i%);
    rec b1(t)
    {
        %assert(i > 0);%
        if (t == 1) {
            up := 1;
        }
        if (t == 10) {
            up := 0;
        }
        if (up == 1) {
            t := t+1;
        } else {
            t := t-1;
        }

        %i := i - 1;%
    }
    
    return ;
}
