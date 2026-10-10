/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

#include <stdio.h>

int main() {
    int x, y, n;
	scanf("%d%d", &x, &y);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	n = x;
	if (x >= 0) {
		while (x >= 0) {
			printf("x:%d,y:%d\n", x, y);
			y = 1;
			if (y < x) {
				while (y < x) {
					y = 2*y;
                }
			}
			x = x - 1;
		}
	}
	return 0;
}
