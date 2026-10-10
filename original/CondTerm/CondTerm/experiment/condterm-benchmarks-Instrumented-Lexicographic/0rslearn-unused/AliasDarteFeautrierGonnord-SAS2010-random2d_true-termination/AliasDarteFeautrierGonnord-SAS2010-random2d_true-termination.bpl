/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(t : int, N : int, x : int, y : int, r : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, N : int, x : int, y : int, r : int): bool;

procedure main() {
	var N : int;
	var x : int;
	var y : int;
	var t : int;
	var r, i : int;
	N := 10;
    x := 0;
    y := 0;
    t := 0;

    assume(%M:i%);

	while (t < N)
    invariant b0(t, N, x, y, r,i %Inv:i%);
	rec b1(t, N, x, y, r)
	{
        %assert(i > 0);%
		t := t + 1;
		havoc r;
		if (r >= 0 && r <= 3) {
			if (r == 0) {
				x := x + 1;
			} else {if (r == 1) {
				x := x - 1;
			} else {if (r == 2) {
				y := y + 1;
			} else {if (r == 3) {
				y := y - 1;
            }}}}
		}

        %i := i - 1;%
	}
	return;
}
