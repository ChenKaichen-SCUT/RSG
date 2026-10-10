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
    while (x < 0) {
        printf("%d,%d\n", x, y);
        x = x + y;
        y = y - 1;
    }
    return 0;
}
