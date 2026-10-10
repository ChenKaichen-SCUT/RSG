/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

#include <stdio.h>

int main() {
    int _i, x, n, b, t;
	scanf("%d%d%d%d", &x, &n, &b, &_i);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (b >= 1) {
		t = 1;
	} else {
		t = -1;
    }
	while (x <= n) {
		printf("x:%d,n:%d,t:%d,b:%d\n", x, n, t, b);
		if (b >= 1) {
			x = x + t;
		} else {
			x = x - t;
		}
	}
	return 0;
}
