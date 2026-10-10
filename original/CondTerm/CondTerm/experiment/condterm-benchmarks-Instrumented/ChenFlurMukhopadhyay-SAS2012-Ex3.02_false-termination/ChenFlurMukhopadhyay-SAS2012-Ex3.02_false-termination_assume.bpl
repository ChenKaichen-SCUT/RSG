/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 *
 * This is Example 3.2 from the test suit used in
 *
 * Termination Proofs for Linear Simple Loops.
 * Hong Yi Chen, Shaked Flur, and Supratik Mukhopadhyay.
 * SAS 2012.
 *
 * The test suite is available at the following URL.
 * https://tigerbytes2.lsu.edu/users/hchen11/lsl/LSL_benchmark.txt
 *
 * Comment: non-terminating (for x>0, y>=0, z>=0)
 */

function {:existential true} b0(x : int, y : int, z : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int, z : int): bool;

procedure main() {
    var x : int;
    var y : int;
    var z, i : int;
    havoc x;
    havoc y;
    havoc z;

    assume(%M:i%);

  assume (((x <= 0) || (z <= 0) || (z > 1) || (x + y <= 1) || (y + z <= -1)) && ((x <= 0) || (z <= 1) || (z > 2) || (x <= -y) || (y + z <= -1)) && ((x <= 0) || (z <= 0) || (z > 1) || (x + y <= 2) || (y + z <= -2) || (y + z > -1)) && ((x <= 0) || (z <= 1) || (z > 2) || (x <= -y) || (x + y <= 1) || (y + z <= -2) || (y + z > -1)) && ((x <= 0) || ((y <= -1) && (x <= -y)) || ((z <= -1) && (x <= -y)) || ((y <= -1) && (z <= 0) && (z <= 1)) || ((z <= -1) && (z <= 0) && (z <= 1)) || ((y <= -1) && (z <= 0) && (y <= -z)) || ((y <= -1) && (z <= 1) && (y + z <= -1)) || ((z <= -1) && (z <= 0) && (y <= -z)) || ((z <= -1) && (z <= 1) && (y + z <= -1)) || ((y <= -1) && (y <= -z) && (y + z <= -1)) || ((z <= -1) && (y <= -z) && (y + z <= -1)))); // CondTerm
    while (x > 0)
        invariant b0(x,y,z,i %Inv:i%);
        rec b1(x, y, z)
    {
        %assert(i > 0);%
        x := x + y;
        y := y + z;

        %i := i - 1;%
    }
    return;
}
