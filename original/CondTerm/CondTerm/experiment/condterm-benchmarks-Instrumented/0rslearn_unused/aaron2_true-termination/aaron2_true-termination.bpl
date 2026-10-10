/*
 * Program used in the experimental evaluation of the following papers.
 * 2008ESOP - Chawdhary,Cook,Gulwani,Sagiv,Yang - Ranking Abstractions
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program 
 *           Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(x : int, y : int, tx : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, tx : int): bool;

procedure main()
{
    var x, y, tx, t, i : int;
    
    assume(%M:i%);

	while (x >= y && tx >= 0) 
	invariant b0(x,y,tx,i %Inv:i%);
        rec b1(x, y, tx)
    {
        %assert(i > 0);%
        
        havoc t;
	if (t != 0) {
		x := x - 1 - tx;
	} else {
		y := y + 1 + tx;
	}
	
	%i := i - 1;%
   }
	return;
}
