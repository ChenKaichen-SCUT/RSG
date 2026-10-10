/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 * (a, b) is a vector that is rotated around (0, 0) and scaled by a factor of 5.
 * I.e., (a, b) is on an outward spiral around (0, 0).
 *
 * This program terminates because on average, (a, b) is (0, 0),
 * hence q decreases by 1 on average.
 */

function {:existential true} b0(q : int, a : int, b : int, olda: int, i:int %Decl:i%): bool;
function {:existential true} b1(q : int, a : int, b : int, olda: int): bool;

procedure main()
{
    var a : int;
    var b : int;
    var q : int;
    var olda, i : int;
    havoc a;
    havoc b;
    havoc q;
    
    assume(%M:i%);
    
	while (q > 0)
	invariant b0(q, a, b, olda,i %Inv:i%);
        rec b1(q, a, b, olda)
    {
    		%assert(i > 0);%
    		
		q := q + a - 1;
		olda := a;
		a := 3*olda - 4*b;
		b := 4*olda + 3*b;
		
		%i := i - 1;%
	}
	return ;
}
