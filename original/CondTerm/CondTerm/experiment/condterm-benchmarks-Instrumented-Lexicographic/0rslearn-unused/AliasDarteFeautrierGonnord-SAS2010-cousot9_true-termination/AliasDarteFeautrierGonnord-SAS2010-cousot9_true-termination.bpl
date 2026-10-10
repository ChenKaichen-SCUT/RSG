/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(i : int, j : int, N : int %Decl:m%): bool;
function {:existential true} b1(i : int, j : int, N : int): bool;

procedure main() {
	var i : int;
	var j : int;
	var N, m : int;
	havoc j;
	havoc N;
	i := N;
	
	assume(%M:m%);
	
	while (i > 0) 
	invariant b0(i,j,N %Inv:m%);
	rec b1(i, j, N)
	{
		%assert(m > 0);%
		if (j > 0) {
			j := j - 1;
		} else {
			j := N;
			i := i - 1;
		}
		
		%m := m - 1;%
	}
	return;
}
