/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 *
 * This is Example 3.6 from the test suit used in
 *
 * Termination Proofs for Linear Simple Loops.
 * Hong Yi Chen, Shaked Flur, and Supratik Mukhopadhyay.
 * SAS 2012.
 *
 * The test suite is available at the following URL.
 * https://tigerbytes2.lsu.edu/users/hchen11/lsl/LSL_benchmark.txt
 *
 * Comment: non-terminating (for x=-1, y=1, z=-1)
 */

function {:existential true} b0(x : int, y : int, z : int %FD%): bool;
function {:existential true} b1(x : int, y : int, z : int): bool;

procedure main() {
    var x : int;
    var y : int;
    var z %VD%: int;
    havoc x;
    havoc y;
    havoc z;

    %BE%

    while (x < 0)
        invariant b0(x,y,z %IC%);
        rec b1(x, y, z)
    {
        %BT%
        x := x + z;
        z := -2 * y;
        y := y + 1;

        %IT%
    }
    return;
}
