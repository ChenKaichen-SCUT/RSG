/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(x : int, max: int , a : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, max: int , a : int): bool;

procedure main() {
	var a : int;
	var x : int;
	var max : int;
	var t, i : int;
	havoc max;
	if (max > 0) 
	{
		a := 0;
		x := 1;

        assume(%M:i%);

		while (x <= max)
        invariant b0(x, max, a,i %Inv:i%);
            rec b1(x, max, a)
        {
            %assert(i > 0);%
			havoc t;
			if (t != 0) {
				a := a + 1;
			} else {
				a := a - 1;
            }
			x := x + 1;

            %i := i - 1;%
		}
	}
	return;
}
