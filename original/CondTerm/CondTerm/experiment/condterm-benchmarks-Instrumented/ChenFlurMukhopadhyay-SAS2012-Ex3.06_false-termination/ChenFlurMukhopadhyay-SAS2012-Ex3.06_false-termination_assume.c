#include <assert.h>
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

#include <stdio.h>

int main() {
    int x, y, z;
    scanf("%d%d%d", &x, &y, &z);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
  assert (((x > -1) || ((y <= -2) && (y <= -1)) || ((y <= -1) && (x + z > -3)) || ((y > -1) && (z > 0) && (x + z > -1))) && ((y <= 9) || (x > 7) || (x + y > 8) || (x + z > 9) || (y + z > 9) || (y - z <= -21) || (x - y > 7) || (x - z > 18)) && ((y <= -7) || (x > -1) || (x + y <= 8) || (x + y > 9) || (x + z > 10) || (y + z > 9) || (y - z <= -21) || (x - y > 7) || (x - z > 18)) && ((y <= -3) || (x > 7) || (y > -2) || (z > 8) || (y + z <= -22) || (x + y > 8) || (x + z > -7) || (y + z > 9) || (y - z <= -15) || (x - y > 1) || (x - z > 18)) && ((y <= -2) || (x > 7) || (y > 9) || (z > 8) || (y + z <= -22) || (x + y > -14) || (x + z > 3) || (y + z > 9) || (y - z <= -15) || (x - y > 1) || (x - z > 18)) && ((y <= -1) || (x > -1) || (x > y) || (y > 9) || (z > 8) || (x + y <= -14) || (y + z <= -8) || (x + y > 8) || (x + z > -1) || (y + z > 9) || (y - z <= -4) || (x - y > 1) || (x - z > 18)) && ((y <= -2) || (x > 7) || (x > y) || (y > 9) || (z > 8) || (x + y <= -14) || (y + z <= -8) || (x + y > 8) || (x + z > -3) || (y + z > 9) || (y - z <= -6) || (x - y > 1) || (x - z > 18) || (y - z > -5))); // CondTerm
    while (x < 0) {
        printf("x:%d,y:%d,z:%d\n", x, y, z);
        x = x + z;
        z = -2*y;
        y = y + 1;
    }
    return 0;
}
