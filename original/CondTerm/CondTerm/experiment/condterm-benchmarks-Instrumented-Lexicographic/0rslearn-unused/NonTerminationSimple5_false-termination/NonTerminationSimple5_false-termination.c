/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

#include <stdio.h>
#include <stdlib.h>

int main()
{
	int x, t;
    scanf("%d", &x);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	while (x >= 0) {
		printf("%d\n", x);
		t = rand();
		if (t != 0) {
			printf("L1\n");
			x = x - 1;
		} else {
			printf("L2\n");
			x = x + 1;
		}
	}
	return 0;
}
