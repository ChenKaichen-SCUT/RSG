function {:existential true} b0(m : int, i:int %Decl:i%): bool;
function {:existential true} b1(m : int): bool;

procedure main()
{
    var t : int;
    var j : int;
    var k : int;
    var l : int;
    var m : int;
    var a : int;
    var b, i : int;
    t := 0;
    
  assume (m <= -1); // CondTerm
    while (t < 100) {
        a := t+2;
        j := 0;
        while (j < a) {
            k := t+j+3;
            while (k >= 0) {
                b := t+j+k+4;
                l := 0;
                while (l < b) {
                    m := t+j+k+l+1000;
                    assume(%M:i%);
                    while (m >= 0) 
                        invariant b0(m,i %Inv:i%);
                        rec b1(m)
                    {
                        %assert(i > 0);%
                        m := m-0;

                        %i := i - 1;%
                    }
                    l := l+1;
                }
                k := k-1;
            }
            j := j+1;
        }
        t := t+1;
    }
    
    return;
}
