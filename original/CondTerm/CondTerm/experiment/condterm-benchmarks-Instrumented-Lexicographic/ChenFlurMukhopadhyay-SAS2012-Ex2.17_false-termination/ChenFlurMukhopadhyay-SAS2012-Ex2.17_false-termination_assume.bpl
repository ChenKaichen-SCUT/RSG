/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 *
 * This is Example 2.17 from the test suit used in
 *
 * Termination Proofs for Linear Simple Loops.
 * Hong Yi Chen, Shaked Flur, and Supratik Mukhopadhyay.
 * SAS 2012.
 *
 * The test suite is available at the following URL.
 * https://tigerbytes2.lsu.edu/users/hchen11/lsl/LSL_benchmark.txt
 *
 * Comment: non-terminating (for x=0, y=11)
 */

function {:existential true} b0(x : int, y : int %FD%): bool;
function {:existential true} b1(x : int, y : int): bool;

procedure main() {
    var x : int;
    var y %VD%: int;
    havoc x;
    havoc y;

    %BE%

  assume (((y <= -10) || (x > 9)) && ((y <= -5) || (x > 7)) && ((y <= -9) || (x + y > 1)) && ((y <= -8) || (x + y > 2)) && ((y <= -7) || (x + y > 3)) && ((y <= -6) || (x + y > 4))); // CondTerm
    while (x < 10)
        invariant b0(x,y %IC%);
        rec b1(x, y)
    {
        %BT%
        x := -y;
        y := y + 1;

        %IT%
    }
    return;
}
