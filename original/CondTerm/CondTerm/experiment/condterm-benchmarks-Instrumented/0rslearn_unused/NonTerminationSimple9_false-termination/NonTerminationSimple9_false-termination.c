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
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	while (x >= 0) {
		printf("x:%d,t:%d\n", x, t);
		t = rand();
		x = x + t;
	}
	return 0;
}
