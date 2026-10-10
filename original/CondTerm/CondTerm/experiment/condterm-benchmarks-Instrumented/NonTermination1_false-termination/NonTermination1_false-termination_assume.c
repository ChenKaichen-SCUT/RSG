#include <assert.h>
/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 */

#include <stdio.h>

int main() {
	int x;
    scanf("%d", &x);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
  assert (x <= 1); // CondTerm
	while (x > 1) {
		printf("x:%d\n", x);
		x = 2*x;
	}
	return 0;
}
