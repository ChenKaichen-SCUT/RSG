/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

function {:existential true} b0(da : int, r: int, db : int, temp : int, i:int %Decl:i%): bool;
function {:existential true} b1(da : int, r: int, db : int, temp : int): bool;

procedure main() {
	var r : int;
	var da : int;
	var db : int;
	var temp : int;
	var _i, i : int;
	havoc r;
	if (r >= 0) 
	{
		da := 2 * r;
		db := 2 * r;

        assume(%M:i%);

		while (da >= r)
        invariant b0(da, r, db, temp,i %Inv:i%);
        rec b1(da, r, db, temp)
        {
            %assert(i > 0);%
			havoc _i;
			if (_i != 0) {
				da := da - 1;
			} else {
				temp := da;
				da := db - 1;
				db := da;
			}

            %i := i - 1;%
		}
	}
	return;
}
