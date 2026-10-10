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
    int x, y, m;
	y = 0;
	scanf("%d", &m);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    x = m;
	while (x >= 0 && y >= 0) {
		printf("m:%d\n", m);
		if (rand() != 0) {
			while (y <= m && rand() != 0) {
				y = y + 1;
			}
			x = x - 1;
		}
		y = y - 1;
	}
	return 0;
}
