/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

#include <stdio.h>

int main()
{
	int c, x;
    c = 5;
    scanf("%d", &x);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	while (x >= 0) {
		printf("%d\n", x);
		x = x + c;
	}
	return 0;
}
