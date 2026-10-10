#include <assert.h>
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

#include <stdio.h>

int main() {
    int x, y;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
  assert (((y <= -10) || (x > 9)) && ((y <= -5) || (x > 7)) && ((y <= -9) || (x + y > 1)) && ((y <= -8) || (x + y > 2)) && ((y <= -7) || (x + y > 3)) && ((y <= -6) || (x + y > 4))); // CondTerm
    while (x < 10) {
        printf("x:%d,y:%d\n", x, y);
        x = -y;
        y = y + 1;
    }
    return 0;
}
