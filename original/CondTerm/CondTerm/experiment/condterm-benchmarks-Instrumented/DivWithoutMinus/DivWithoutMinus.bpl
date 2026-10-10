function {:existential true} b0(x : int, y : int, z : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, z : int): bool;

procedure main()
{
    var x : int;
    var y : int;
    var z, i : int;
    var res : int;

    havoc x;
    havoc y;
    z := y;
    res := 0;

    assume(%M:i%);

    while ((0 == y || (y > 0 && x > 0)) && z > 0)
        invariant b0(x,y,z,i %Inv:i%);
        rec b1(x, y, z)
    {
        %assert(i > 0);%
        if (y == 0) {
            res := res + 1;
            y := z;
        }
        else {
            x := x + 1;
            y := y - 1;
        }

        %i := i - 1;%
    }
    return;
}

