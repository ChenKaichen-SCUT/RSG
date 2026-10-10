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
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	while (a >= 7) {
		printf("a:%d,b:%d, olda:%d\n", a, b, olda);
		olda = a;
		a = b;
		b = olda + 1;
		// b = a + 1; is a typo in the paper
	}
	return 0;
}
