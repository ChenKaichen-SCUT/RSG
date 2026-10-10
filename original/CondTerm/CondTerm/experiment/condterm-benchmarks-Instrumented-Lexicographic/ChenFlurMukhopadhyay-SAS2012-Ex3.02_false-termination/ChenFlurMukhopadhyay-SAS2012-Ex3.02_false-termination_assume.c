#include <assert.h>
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

#include <stdio.h>

int main() {
    int x, y, z;
    scanf("%d%d%d", &x, &y, &z);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
  assert (((x <= 0) || (z <= 0) || (z > 1) || (x + y <= 1) || (y + z <= -1)) && ((x <= 0) || (z <= 1) || (z > 2) || (x <= -y) || (y + z <= -1)) && ((x <= 0) || (z <= 0) || (z > 1) || (x + y <= 2) || (y + z <= -2) || (y + z > -1)) && ((x <= 0) || (z <= 1) || (z > 2) || (x <= -y) || (x + y <= 1) || (y + z <= -2) || (y + z > -1)) && ((x <= 0) || ((y <= -1) && (x <= -y)) || ((z <= -1) && (x <= -y)) || ((y <= -1) && (z <= 0) && (z <= 1)) || ((z <= -1) && (z <= 0) && (z <= 1)) || ((y <= -1) && (z <= 0) && (y <= -z)) || ((y <= -1) && (z <= 1) && (y + z <= -1)) || ((z <= -1) && (z <= 0) && (y <= -z)) || ((z <= -1) && (z <= 1) && (y + z <= -1)) || ((y <= -1) && (y <= -z) && (y + z <= -1)) || ((z <= -1) && (y <= -z) && (y + z <= -1)))); // CondTerm
    while (x > 0) {
        printf("%d,%d,%d\n", x, y, z);
        x = x + y;
        y = y + z;
    }
    return 0;
}
