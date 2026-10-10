/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

// function {:existential true} b0(i : int, j : int): bool;
function {:existential true} b0(t : int, n : int, j : int, k : int, i:int %Decl:i%): bool;
function {:existential true} b1(t : int, n : int, j : int, k : int): bool;

procedure main() {
	var t : int;
	var j : int;
	var k : int;
	var m : int;
	var n : int;
	var N, i : int;
	havoc t;
	havoc j;
	havoc k;
	havoc n;
	havoc m;
	havoc N;
	if (0 <= n && 0 <= m && 0 <= N) {
		t := 0;

        assume(%M:i%);

		while (t < n) 
        invariant b0(t, n, j, k,i %Inv:i%);
        rec b1(t, n, j, k)
        {
            %assert(i > 0);%
			j := 0;
			while (j < m) {
				j := j + 1;
				k := t;
				while (k < N) {
					k := k + 1;
                }
				t := k;
			}
			t := t + 1;

            %i := i - 1;%
		}
	}
	return;
}
