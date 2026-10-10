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

#include <stdio.h>

int main() {
    int x, y, oldx;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    while (4*x + y > 0) {
        printf("x:%d,y:%d\n", x, y);
        oldx = x;
        x = -2*oldx + 4*y;
        y = 4*oldx;
    }
    return 0;
}
