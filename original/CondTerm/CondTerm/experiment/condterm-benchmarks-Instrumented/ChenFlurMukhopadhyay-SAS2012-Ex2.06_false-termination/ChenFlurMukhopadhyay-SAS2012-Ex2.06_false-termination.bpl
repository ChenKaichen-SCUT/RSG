/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 *
 * This is Example 2.6 from the test suit used in
 *
 * Termination Proofs for Linear Simple Loops.
 * Hong Yi Chen, Shaked Flur, and Supratik Mukhopadhyay.
 * SAS 2012.
 * 
 * The authors of the paper claim that this program is terminating, however
 * the program is nonterminating (e.g., initial state x=1 and y=1).
 *
 * The test suite is available at the following URL.
 * https://tigerbytes2.lsu.edu/users/hchen11/lsl/LSL_benchmark.txt
 *
 * Comment: terminating, non-linear
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

    while (4 * x + y > 0)
        invariant b0(x,y,i %Inv:i%);
        rec b1(x, y)
    {
        %assert(i > 0);%
        oldx := x;
        x := -2 * oldx + 4 * y;
        y := 4 * oldx;

        %i := i - 1;%
    }
    return;
}
