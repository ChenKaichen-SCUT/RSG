/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(x : int, y : int, n : int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, n : int): bool;

procedure main() {
	var x : int;
	var y : int;
	var n : int;
	var k, j : int;
	var i : int;
	havoc n;
	havoc x;
	havoc y;
	
	assume(%M:i%);
	
	while (x >= 0) 
	invariant b0(x,y,n,i %Inv:i%);
	rec b1(x, y, n)
	{
		%assert(i > 0);%
		havoc k;
		while (y >= 0 && k != 0) {
			y := y - 1;
        	}
		x := x - 1;
		havoc j;
		while (y <= n && j != 0) {
			y := y + 1;
        	}
        	
        	%i := i - 1;%
	}
	return;
}
