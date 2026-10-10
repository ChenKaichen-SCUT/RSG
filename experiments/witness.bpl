// Mathematical integers; the unconstrained entry is all pairs of integers.
function {:existential true} b1(p:int, x:int): bool;
procedure main()
{
    var p:int;
    var x:int;
    havoc p,x;
    while ((p == 0 && 0 <= x && x <= 2) || (p == 1 && 3 <= x && x <= 4))
        rec b1(p,x)
    {
        x := 4-x;
        p := 1-p;
    }
    return;
}
