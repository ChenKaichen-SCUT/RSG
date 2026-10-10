/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */
 function {:existential true} b0(a : int, b : int, i:int %Decl:i%): bool;
function {:existential true} b1(a : int, b : int): bool;

procedure main() 
{
	var a : int;
	var b : int;
	havoc a;
	havoc b;
	
	assume(%M:i%);
	
	while (a < 30) 
	invariant b0(a,b,i %Inv:i%);
	rec b1(a, b)
	{	
		%assert(i > 0);%
			
		while (b < a) {
			if (b > 5) {
				b := b + 7;
			} else {
				b := b + 2;
            }
			if (b >= 10 && b <= 12) {
				a := a + 10;
			} else {
				a := a + 1;
            }
		}
		a := a + 2;
		b := b - 10;
		
		%i := i - 1;%
	}
	return;
}
