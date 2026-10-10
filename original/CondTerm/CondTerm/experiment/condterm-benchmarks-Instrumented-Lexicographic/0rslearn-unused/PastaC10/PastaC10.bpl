function {:existential true} b0(t : int, j : int, tmp : int %FD%): bool;
function {:existential true} b1(t : int, j : int, tmp : int): bool;

procedure main()
{
    var t : int;
    var j : int;
    var r : int;
    var tmp %VD%: int;
    havoc t;
    havoc j;

  %BE%

    while (t - j >= 1)
    invariant b0(t, j, tmp %IC%);
    rec b1(t, j, tmp)
    {
    %BT%
        havoc tmp;
        t := t - tmp;
        havoc tmp;
        r := tmp + 1;
        j := j + r;

    %IT%
    }

    return;
}
