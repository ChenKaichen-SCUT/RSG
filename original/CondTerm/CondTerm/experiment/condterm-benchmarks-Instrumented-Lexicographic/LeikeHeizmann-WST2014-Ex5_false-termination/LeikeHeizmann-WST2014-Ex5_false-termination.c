/*
 * Program from Example 5 of
 * 2014WST - Leike, Heizmann - Geometric Series as Nontermination Arguments for Linear Lasso Programs
 *
 * Date: 2014-06-29
 * Author: Jan Leike
 */

#include <stdio.h>

int main() {
    int a, b, olda;
    scanf("%d%d", &a, &b);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	while (a >= 7) {
		printf("%d,%d\n", a, b);
		olda = a;
		a = b;
		b = olda + 1;
		// b = a + 1; is a typo in the paper
	}
	return 0;
}
