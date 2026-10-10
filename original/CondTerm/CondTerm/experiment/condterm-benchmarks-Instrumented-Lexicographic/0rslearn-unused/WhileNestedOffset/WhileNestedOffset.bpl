function {:existential true} b0(j : int %FD%): bool;
function {:existential true} b1(j : int): bool;

procedure main()
{
    var t : int;
    var j %VD%: int;
    havoc t;

    while (t < 10) {
        j := t;
  %BE%
        while (j > 5)
            invariant b0(j %IC%);
            rec b1(j)
        {
    %BT%
            j := j+1;

    %IT%
        }
        t := t+1;
    }

    return ;
}
