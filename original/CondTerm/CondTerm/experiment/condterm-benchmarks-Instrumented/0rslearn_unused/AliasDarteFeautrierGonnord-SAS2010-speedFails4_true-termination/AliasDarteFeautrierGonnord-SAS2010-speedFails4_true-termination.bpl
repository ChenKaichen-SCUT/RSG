/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(x : int, n : int, t : int, b : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, n : int, t : int, b : int): bool;

procedure main() {
	var _i : int;
	var x : int;
	var n : int;
	var b : int;
	var t, i : int;
	havoc _i;
	havoc x;
	havoc n;
	havoc b;
	if (b >= 1) {
		t := 1;
	} else {
		t := -1;
    }

    assume(%M:i%);

	while (x <= n) 
    invariant b0(x, n, t, b,i %Inv:i%);
	rec b1(x, n, t, b)
	{
        %assert(i > 0);%
		if (b >= 1) {
			x := x + t;
		} else {
			x := x - t;
		}

        %i := i - 1;%
	}
	return;
}
