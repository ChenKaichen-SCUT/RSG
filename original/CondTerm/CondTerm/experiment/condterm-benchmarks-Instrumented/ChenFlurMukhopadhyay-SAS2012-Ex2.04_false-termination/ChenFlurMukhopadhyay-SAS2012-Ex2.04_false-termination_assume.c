#include <assert.h>
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

#include <stdio.h>

int main() {
    int x, y;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
  assert (((x <= -14) || (y <= -1) || (x > -6) || (y > 0) || (x + y <= -10) || (x + y > -9) || (x - y > -3)) && ((x <= -9) || (y <= -1) || (x > -3) || (y > 0) || (x + y <= -12) || (x + y > 1) || (x - y > -1)) && ((x <= -12) || (y <= -1) || (x > -7) || (y > 0) || (x + y <= -11) || (x > -y) || (x + y > -10) || (x - y > -4)) && ((x <= -13) || (y <= -1) || (x > -12) || (y > 0) || (x + y <= -23) || (x + y > 5) || (x - y <= -26) || (x - y > -9)) && (((x <= -3) && (x <= -2)) || ((x <= -3) && (y <= -1)) || ((x <= -3) && (x > -1)) || ((x <= -3) && (y > 0)) || ((x <= -2) && (x + y > -2)) || ((y <= -1) && (x + y > -2)) || ((x > -1) && (x + y > -2)) || ((y > 0) && (x + y > -2)) || ((x <= -2) && (x - y > -2)) || ((y <= -1) && (x - y > -2)) || ((x > -1) && (x - y > -2)) || ((y > 0) && (x - y > -2)))); // CondTerm
    while (x < y) {
        printf("x:%d,y:%d\n", x, y);
        x = x + y;
        y = -2*y;
    }
    return 0;
}
