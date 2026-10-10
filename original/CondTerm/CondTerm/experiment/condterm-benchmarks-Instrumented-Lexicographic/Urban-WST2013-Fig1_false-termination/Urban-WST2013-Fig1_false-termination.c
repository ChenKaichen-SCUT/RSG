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
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    while (x <= 10) {
        printf("%d\n", x);
        if (x > 6) {
            printf("L1\n");
            x = x + 2;
        }
    }
    return 0;
}
