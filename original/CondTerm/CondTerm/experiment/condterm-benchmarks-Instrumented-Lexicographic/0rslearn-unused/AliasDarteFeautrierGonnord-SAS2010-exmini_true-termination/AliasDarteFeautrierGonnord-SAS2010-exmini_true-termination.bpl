/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(t : int, j : int, k : int, tmp : int, i : int %Decl:i%): bool;
function {:existential true} b1(t : int, j : int, k : int, tmp : int): bool;

procedure main() {
	var t : int;
	var j : int;
	var k : int;
	var tmp,i : int;
	havoc t;
	havoc j;
	havoc k;
	havoc tmp;
	
	assume(%M:i%);
	
	while (t <= 100 && j <= k) 
	invariant b0(t,j,k,tmp,i %Inv:i%);
    rec b1(t, j, k, tmp)
    {
    	%assert(i > 0);%
		tmp := t;
		t := j;
		j := tmp + 1;
		k := k - 1;
		
		%i := i - 1;%
	}
	return;
}
