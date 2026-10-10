/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Rotates x and y by 90 degrees
 * Does not terminate.
 */

#include <stdio.h>

int main ()
{
    int oldx;
	int x;
	int y;
	scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	while (1) {
		printf("%d,%d\n", x, y);
        oldx = x;
		x = -y;
		y = oldx;
	}
	return 0;
}
