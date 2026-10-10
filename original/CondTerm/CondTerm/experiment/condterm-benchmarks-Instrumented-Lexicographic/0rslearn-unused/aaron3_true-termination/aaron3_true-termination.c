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
    int x, y, z, tx;
    scanf("%d%d%d%d", &x, &y, &tx, &z);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

	while (x >= y && x <= tx + z) {
		printf("x:%d,y:%d,tx:%d,z:%d\n", x, y, tx, z);
		
		if (__VERIFIER_nondet_int() != 0) {
			z = z - 1;
			tx = x;
			x = __VERIFIER_nondet_int();
		} else {
			y = y + 1;
		}
	}
	return 0;
}
