/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Very simple example for non-termination
 */
#include <stdio.h>

int main()
{
	int x;
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	while (1) {
		printf("x:%d\n", x);
		// do nothing
	}
	return 0;
}
