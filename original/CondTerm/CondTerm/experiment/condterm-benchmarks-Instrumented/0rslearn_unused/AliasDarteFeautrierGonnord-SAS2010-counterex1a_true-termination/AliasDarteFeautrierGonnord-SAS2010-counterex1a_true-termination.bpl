/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(x : int, y : int, n : int, b : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, n : int, b : int): bool;

procedure main() {
	var x : int;
	var y : int;
	var n : int;
	var b : int;
	var i : int;
	havoc n;
	havoc b;
	havoc x;
	havoc y;
	
	assume(%M:i%);
	
	while (x >= 0 && 0 <= y && y <= n) 
	invariant b0(x,y,n,b,i %Inv:i%);
	rec b1(x, y, n, b)
	{
		%assert(i > 0);%
		
		if (b == 0) {
			y := y + 1;
			havoc i;
			if (i != 0) {
				b := 1;
            }
		} else {
			y := y - 1;
			havoc i;
			if (i != 0) {
				x := x - 1;
				b := 0;
			}
		}
		
		%i := i - 1;%
	}
	return;
}
