#include <assert.h>
/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 *
 * This is Example 2.2 from the test suit used in
 *
 * Termination Proofs for Linear Simple Loops.
 * Hong Yi Chen, Shaked Flur, and Supratik Mukhopadhyay.
 * SAS 2012.
 *
 * The test suite is available at the following URL.
 * https://tigerbytes2.lsu.edu/users/hchen11/lsl/LSL_benchmark.txt
 *
 * Comment: nonterminating
 */

#include <stdio.h>

int main() {
    int x, y;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
  assert (((x > -1) || (y > 1) || (x + y > -1)) && ((y <= 1) || (x > -1) || (y > 2) || (x + y > -2)) && ((y <= 2) || (x > -1) || (y > 3) || (x + y > -4)) && ((y <= 3) || (x > -1) || (y > 4) || (x + y > -7)) && ((y <= 4) || (x > -1) || (y > 7) || (x + y > -22)) && ((x > -22) || (y > 6) || (x + y > 11) || (x - y > 5)) && ((y <= 4) || (x > -1) || (y > 5) || (x + y <= -22) || (x + y > -11)) && ((y <= 5) || (x > -1) || (y > 6) || (x + y <= -22) || (x + y > -16)) && ((x <= -22) || (x > -1) || (y > 5) || (x + y > -11) || (x - y > 5)) && ((x <= -22) || (x > -1) || (y > 1) || (x + y <= -11) || (x + y > -1) || (x - y > 5)) && ((x <= -22) || (y <= 1) || (x > -1) || (y > 2) || (x + y <= -11) || (x + y > -2) || (x - y > 5)) && ((x <= -22) || (y <= 2) || (x > -1) || (y > 3) || (x + y <= -11) || (x + y > -4) || (x - y > 5)) && ((x <= -22) || (y <= 3) || (x > -1) || (y > 4) || (x + y <= -11) || (x + y > -7) || (x - y > 5)) && ((x > -1) || ((y > 0) && (y > 1) && (y > 2) && (y > 3)) || ((y <= 1) && (y > 0) && (y > 2) && (x + y > -1)) || ((y > 0) && (y > 1) && (y > 2) && (x + y > -4)) || ((y > 0) && (y > 1) && (y > 3) && (x + y > -2)) || ((y <= 1) && (y > 0) && (x + y > -2) && (x + y > -1)) || ((y > 0) && (y > 1) && (x + y > -4) && (x + y > -2)))); // CondTerm
    while (x < 0) {
        printf("%d,%d\n", x, y);
        x = x + y;
        y = y - 1;
    }
    return 0;
}
