/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(x : int, y : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
	var x : int;
	var y : int;
	var m, i : int;
	var t, j : int;
	y := 0;
	havoc m;
    x := m;

    assume(%M:i%);

	while (x >= 0 && y >= 0) 
    invariant b0(x,y,i %Inv:i%);
	rec b1(x, y)
	{
        %assert(i > 0);%
		havoc t;
		if (t != 0) {
			havoc j;
			while (y <= m && j != 0) {
				y := y + 1;
			}
			x := x - 1;
		}
		y := y - 1;

        %i := i - 1;%
	}
	return;
}
