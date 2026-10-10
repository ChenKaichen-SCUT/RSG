/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 *
 * This is Example 2.12 from the test suit used in
 *
 * Termination Proofs for Linear Simple Loops.
 * Hong Yi Chen, Shaked Flur, and Supratik Mukhopadhyay.
 * SAS 2012.
 *
 * The test suite is available at the following URL.
 * https://tigerbytes2.lsu.edu/users/hchen11/lsl/LSL_benchmark.txt
 *
 * Comment: non-terminating (for x=0,y=0)
 */

function {:existential true} b0(x : int, y : int, i:int %Decl:i%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y : int;
    var oldx, i : int;
    havoc x;
    havoc y;
    havoc oldx;

    assume(%M:i%);

    while (x < 5)
        invariant b0(x,y,i %Inv:i%);
        rec b1(x, y)
    {
        %assert(i > 0);%
        oldx := x;
        x := oldx - y;
        y := oldx + y;

        %i := i - 1;%
    }
    return;
}
