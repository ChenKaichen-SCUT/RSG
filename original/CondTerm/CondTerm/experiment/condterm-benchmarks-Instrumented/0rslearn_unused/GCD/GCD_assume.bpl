function {:existential true} b0(x : int, y : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main()
{
    var x : int;
    var y : int;
    var tmp : int;
    var xtmp, i : int;
    havoc x;
    havoc y;

    assume(%M:i%);
    
  assume (((x <= 0) || (y > -1)) && ((y <= 0) || (x > -1)) && ((x > -1) || (y > -1)) && ((x <= 0) || (x + y > -1)) && ((y <= 0) || (x + y > -1)) && ((x <= 0) || (y <= 0) || (x > y) || (y > 1)) && ((y <= 1) || (x > y) || (x - y <= -1))); // CondTerm
    while(y != 0) 
    invariant b0(x,y,i %Inv:i%);
    rec b1(x, y)
    {
        %assert(i > 0);%
        tmp := y;
        xtmp := x;
        
        if(x <= 0 || y <= 0) {
            y := 0;
        } else {
            if (x == y) {
                y := 0;
            } else {
                while(xtmp>y) {
                    xtmp := xtmp - y;
                }
            }
        }
        
        y := xtmp;
        x := tmp;

        %i := i - 1;%
    }
    
    return ;
}

