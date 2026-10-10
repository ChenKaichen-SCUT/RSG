/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 */

#include <stdio.h>

int main() {
	int x;
    scanf("%d", &x);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	while (x > 1) {
		printf("%d\n", x);
		x = 2*x;
	}
	return 0;
}
