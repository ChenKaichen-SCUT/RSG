/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

// function {:existential true} b0(): bool;
function {:existential true} b0(x : int, y : int, t : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, t : int): bool;

int main() {
	var x : int;
	var y : int;
	var t, i : int;
	havoc x;
	havoc y;
	while (x >= 2) 
    {
		x := x - 1;
        y := y + x;
		havoc t;

		assume(%M:i%);

		while (y >= x && t != 0) 
		invariant b0(x,y,i %Inv:i%);
        rec b1(x, y, t)
        {
			%assert(i > 0);%
			y := y - 1;

			%i := i - 1;%
		}
		x := x - 1;
        y := y - x;
	}
	return;
}
