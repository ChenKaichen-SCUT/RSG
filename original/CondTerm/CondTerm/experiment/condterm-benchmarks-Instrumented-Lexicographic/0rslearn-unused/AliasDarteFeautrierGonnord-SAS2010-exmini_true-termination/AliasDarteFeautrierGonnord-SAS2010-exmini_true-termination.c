/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

#include <stdio.h>

int main() {
    int t, j, k, tmp;
	scanf("%d%d%d%d", &t, &j, &k, &tmp);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	while (t <= 100 && j <= k) {
		printf("t:%d,j:%d,k:%d,tmp:%d\n", t, j, k, tmp);
		tmp = t;
		t = j;
		j = tmp + 1;
		k = k - 1;
	}
	return 0;
}
