/*
 * Program used in the experimental evaluation of the following papers.
 * 2008ESOP - Chawdhary,Cook,Gulwani,Sagiv,Yang - Ranking Abstractions
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program 
 *           Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */
#include <stdio.h>
typedef enum {false, true} bool;

extern int __VERIFIER_nondet_int(void);

int main() {
    int x, y, tx;
	scanf("%d%d%d", &x, &y, &tx);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	while (x >= y && tx >= 0) {
		printf("x:%d,y:%d,tx:%d\n", x, y, tx);
		if (__VERIFIER_nondet_int() != 0) {
			x = x - 1 - tx;
		} else {
			y = y + 1 + tx;
		}
	}
	return 0;
}
