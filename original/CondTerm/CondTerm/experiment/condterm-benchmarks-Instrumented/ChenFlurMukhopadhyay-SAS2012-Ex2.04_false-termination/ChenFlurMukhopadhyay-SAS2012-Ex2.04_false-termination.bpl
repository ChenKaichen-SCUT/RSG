/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 *
 * This is Example 2.4 from the test suit used in
 *
 * Termination Proofs for Linear Simple Loops.
 * Hong Yi Chen, Shaked Flur, and Supratik Mukhopadhyay.
 * SAS 2012.
 *
 * The test suite is available at the following URL.
 * https://tigerbytes2.lsu.edu/users/hchen11/lsl/LSL_benchmark.txt
 *
 * Comment: non-terminating (for x=-1, y=0)
 */

function {:existential true} b0(x : int, y : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y, i : int;
    havoc x;
    havoc y;

    assume(%M:i%);

    while (x < y)
        invariant b0(x,y,i %Inv:i%);
        rec b1(x, y)
    {
        %assert(i > 0);%
        x := x + y;
        y := -2 * y;

        %i := i - 1;%
    }
    return;
}
