/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */
#include <stdio.h>

int main() {
    int t, n;
	scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	n = t + 1;
	while (t > 1) {
		printf("t:%d\n", t);
		t = t - 1;
	}
	return 0;
}
