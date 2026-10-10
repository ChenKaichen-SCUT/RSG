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
    int N, x, y, t, r;
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	N = 10;
    x = 0;
    y = 0;
    t = 0;
	while (t < N) {
		printf("t:%d,N:%d,x:%d,y:%d,r:%d\n", t, N, x, y, r);
		t = t + 1;
		r = rand();
		if (r >= 0 && r <= 3) {
			if (r == 0) {
				x = x + 1;
			} else {if (r == 1) {
				x = x - 1;
			} else {if (r == 2) {
				y = y + 1;
			} else {if (r == 3) {
				y = y - 1;
            }}}}
		}
	}
	return 0;
}
