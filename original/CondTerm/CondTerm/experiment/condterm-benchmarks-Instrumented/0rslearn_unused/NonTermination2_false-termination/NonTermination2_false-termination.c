/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 */

#include <stdio.h>
#include <stdlib.h>

int main() {
	int x, oldx;
    scanf("%d", &x);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");;
	while (x > 1 && x >= 2*oldx) {
		printf("x:%d,oldx:%d\n", x, oldx);
		oldx = x;
		x = rand();
	}
	return 0;
}
