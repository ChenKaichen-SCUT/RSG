function {:existential true} b0(am : int, bm : int, a : int, b : int, i:int %Decl:i%): bool;
function {:existential true} b1(am : int, bm : int, a : int, b : int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var am : int;
    var bm, i : int;
    am := a;
    bm := b;

    assume(%M:i%);

    while (am != bm) 
    invariant b0(am, bm, a, b,i %Inv:i%);
    rec b1(am, bm, a, b)
    {
        %assert(i > 0);%
        if (am > bm) {
            bm := bm+b;
        } else {
            am := am+a;
        }

        %i := i - 1;%
    }

    return ;
}
