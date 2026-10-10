#include <assert.h>
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
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
  assert ((a <= 0) || (b <= 0)); // CondTerm
	while (a >= 1 && b >= 1) {
		printf("a:%d,b:%d\n", a, b);
		a = 2*a;
		b = 3*b;
	}
	return 0;
}
