/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */
 #include <stdio.h>

typedef enum {false, true} bool;

extern int __VERIFIER_nondet_int(void);

int main() {
    int x, y, n, b;
    scanf("%d%d%d%d", &x, &y, &n, &b);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

	while (x >= 0 && 0 <= y && y <= n) {
		printf("x:%d,y:%d,n:%d,b:%d\n", x, y, n, b);
		
		if (b == 0) {
			y = y + 1;
			if (__VERIFIER_nondet_int() != 0) {
				b = 1;
            }
		} else {
			y = y - 1;
			if (__VERIFIER_nondet_int() != 0) {
				x = x - 1;
				b = 0;
			}
		}
	}
	return 0;
}
