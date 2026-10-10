/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(v1 : int, v2 : int): bool;

procedure main() {
	var m : int;
	var n : int;
	var v1 : int;
	var v2 : int;
	havoc n;
	havoc m;
	if (n >= 0 && m > 0) {
		v1 := n;
		v2 := 0;
		while (v1 > 0)
		rec b0(v1, v2)
		{
			if (v2 < m) {
				v2 := v2 + 1;
				v1 := v1 - 1;
			} else {
				v2 := 0;
			}
		}
	}
	return;
}
