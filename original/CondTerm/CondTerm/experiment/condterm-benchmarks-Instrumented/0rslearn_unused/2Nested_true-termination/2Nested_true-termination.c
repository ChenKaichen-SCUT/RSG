/*
 * Date: 2012-08-10
 * Author: leike@informatik.uni-freiburg.de
 *
 * This program has the following 2-nested ranking function:
 * f_0(x, y) = y + 1
 * f_1(x, y) = x
 */
 #include <stdio.h>

int main()
{
    int x, y;
	scanf("%d%d", &x, &y);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	while (x >= 0) {
		printf("x:%d,y:%d\n", x, y);
		x = x + y;
		y = y - 1;
	}
	return 0;
}
