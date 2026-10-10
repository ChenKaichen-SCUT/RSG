/*
 * Program from Fig.2 of
 * 2013WST - Urban - Piecewise-Defined Ranking Functions
 *
 * Date: 12.12.2012
 * Author: heizmann@informatik.uni-freiburg.de
 *
 */

#include <stdio.h>

int main() {
	int x;
    scanf("%d", &x);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    while (x <= 10) {
        printf("x:%d\n", x);
        if (x > 6) {
            x = x + 2;
        }
    }
    return 0;
}
