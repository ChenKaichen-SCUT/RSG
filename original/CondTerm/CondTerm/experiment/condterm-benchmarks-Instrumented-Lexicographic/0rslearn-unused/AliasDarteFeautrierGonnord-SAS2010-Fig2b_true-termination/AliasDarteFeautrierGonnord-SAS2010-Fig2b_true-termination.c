/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */
#include <stdio.h>
#include <stdlib.h>

int main() {
    int x, y;
	scanf("%d%d", &x, &y);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	while (x >= 2) {
		printf("x:%d,y:%d\n", x, y);
		
		x = x - 1;
        y = y + x;
		while (y >= x + 1 && rand() != 0) {
			y = y - 1;
			while (y >= x + 3 && rand() != 0) {
				x = x + 1;
                y = y - 2;
			}
			y = y - 1;
		}
		x = x - 1;
        y = y - x;
	}
	return 0;
}
