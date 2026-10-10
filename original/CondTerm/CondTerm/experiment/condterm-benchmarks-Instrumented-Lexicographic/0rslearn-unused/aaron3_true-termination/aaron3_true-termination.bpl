/*
 * Program used in the experimental evaluation of the following papers.
 * 2008ESOP - Chawdhary,Cook,Gulwani,Sagiv,Yang - Ranking Abstractions
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program 
 *           Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(x : int, y : int, tx: int, z : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, tx: int, z : int): bool;

procedure main()
{
    var x, y, z, tx, i: int;
    
    assume(%M:i%);
    
	while (x >= y && x <= tx + z) 
    invariant b0(x, y, tx, z,i %Inv:i%);
    rec b1(x, y, tx, z)
    {
    	%assert(i > 0);%
    
        havoc i;
		if (i != 0) {
			z := z - 1;
			tx := x;
            havoc x;
		} else {
			y := y + 1;
		}
		
	%i := i - 1;%
	}
	return;
}
