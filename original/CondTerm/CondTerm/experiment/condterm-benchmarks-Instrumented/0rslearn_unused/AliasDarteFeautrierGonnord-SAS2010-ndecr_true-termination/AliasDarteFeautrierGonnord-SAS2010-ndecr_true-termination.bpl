/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(t : in, i:int %Decl:i%): bool;
function {:existential true} b1(t : int): bool;

procedure main() {
	var t : int;
	var n, i : int;
	havoc t;
    n := t + 1;

    assume(%M:i%);

	while (t > 1) 
    invariant b0(t,i %Inv:i%);
	rec b1(t)
	{
        %assert(i > 0);%
		t := t - 1;

        %i := i - 1;%
	}
	return;
}
