/*
 * Program from Example 6 of
 * 2014WST - Leike, Heizmann - Geometric Series as Nontermination Arguments for Linear Lasso Programs
 *
 * Date: 2014-06-29
 * Author: Jan Leike
 */

#include <stdio.h>

int main() {
    int a, b;
	scanf("%d%d", &a, &b);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	while (a >= 1 && b >= 1) {
		printf("%d,%d\n", a, b);
		a = 2*a;
		b = 3*b;
	}
	return 0;
}
