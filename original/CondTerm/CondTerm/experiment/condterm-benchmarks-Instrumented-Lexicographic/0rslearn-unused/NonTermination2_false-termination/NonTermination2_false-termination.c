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
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	while (x > 1 && x >= 2*oldx) {
		printf("%d\n", x);
		oldx = x;
		x = rand();
	}
	return 0;
}
