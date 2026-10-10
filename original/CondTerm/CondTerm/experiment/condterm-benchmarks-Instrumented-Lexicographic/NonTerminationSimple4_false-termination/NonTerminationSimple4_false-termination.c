/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 *
 * Does not terminate for y >= 5.
 */

#include <stdio.h>

int main()
{
    int x, y;
	scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");

	if (y >= 5) {
	    while (x >= 0) {
			printf("%d,%d\n", x, y);
		    y = y - 1;
    	}
    }
	return 0;
}
