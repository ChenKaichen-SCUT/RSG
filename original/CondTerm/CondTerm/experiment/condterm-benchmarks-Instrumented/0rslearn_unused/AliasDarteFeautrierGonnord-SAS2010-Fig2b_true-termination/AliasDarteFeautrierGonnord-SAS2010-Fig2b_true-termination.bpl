/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

// function {:existential true} b0(i : int, j : int): bool;
function {:existential true} b0(x : int, y : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
	var x : int;
	var y : int;
	var t, j, i : int;
	havoc x;
	havoc y;

    assume(%M:i%);

	while (x >= 2) 
    invariant b0(x,y,i %Inv:i%);
    rec b1(x, y)
    {
        %assert(i > 0);%
		x := x - 1;
        y := y + x;
		havoc t;
		while (y >= x + 1 && t != 0) {
			y := y - 1;
			havoc j;
			while (y >= x + 3 && j != 0) {
				x := x + 1;
                y := y - 2;
			}
			y := y - 1;
		}
		x := x - 1;
        y := y - x;

        %i := i - 1;%
	}
	return;
}
