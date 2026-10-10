/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 *
 * This is Example 2.14 from the test suit used in
 *
 * Termination Proofs for Linear Simple Loops.
 * Hong Yi Chen, Shaked Flur, and Supratik Mukhopadhyay.
 * SAS 2012.
 *
 * The test suite is available at the following URL.
 * https://tigerbytes2.lsu.edu/users/hchen11/lsl/LSL_benchmark.txt
 *
 * Comment: non-terminating (for x=10k, y=3k, any k>0)
 */

function {:existential true} b0(x : int, y : int %FD%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y %VD%: int;
    havoc x;
    havoc y;

    %BE%

  assume ((y <= 2) || (y > 3) || (x + y <= -10) || (x - y <= 6) || (x - y > 7)); // CondTerm
    while (x > 0 && y > 0)
        invariant b0(x,y %IC%);
        rec b1(x, y)
    {
        %BT%
        x := 10 * y - 2 * x;

        %IT%
    }
    return;
}
