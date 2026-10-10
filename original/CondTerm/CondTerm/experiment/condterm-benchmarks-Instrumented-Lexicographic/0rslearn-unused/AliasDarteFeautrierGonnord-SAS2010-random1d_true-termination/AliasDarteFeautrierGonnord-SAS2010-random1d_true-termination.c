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
    int a, x, max;
	scanf("%d%d%d", &x, &max, &a);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (max > 0) {
		a = 0;
		x = 1;
		while (x <= max) {
			printf("x:%d,max:%d,a:%d\n", x, max, a);
			if (rand() != 0) {
				a = a + 1;
			} else {
				a = a - 1;
            }
			x = x + 1;
		}
	}
	return 0;
}
