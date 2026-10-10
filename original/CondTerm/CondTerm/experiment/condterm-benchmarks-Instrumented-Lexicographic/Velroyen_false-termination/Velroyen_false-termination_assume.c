#include <assert.h>
/*
 * Terminating Program for x < -5 OR 0 <= x <= 30 OR x > 35
 * (from benchmarks of) 2008TAP - Velroyen,Rummer - Non-Termination Checking for Imperative Programs
 *
 * Date: 18.12.2013
 * Author: urban@di.ens.fr
 */
#include <stdio.h>

int main() {
	int x;
	scanf("%d", &x);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
  assert (((x <= -6) && (x <= 30)) || ((x <= -6) && (x > 35)) || ((x <= 30) && (x > -1)) || ((x > -1) && (x > 35))); // CondTerm
	while (x!=0) {
		printf("%d\n", x);
	    if (-5 <= x && x <= 35) {
			printf("L1\n");
		    if (x < 0) {
				printf("L2\n");
			    x = -5;
			} else {
				printf("L3\n");
			    if (x > 30) {
					printf("L4\n");
				    x = 35;
				} else {
					printf("L5\n");
					x = x - 1;
				}
			}
		} else {
			printf("L6\n");
		    x = 0;
		}
	}
    return 0;
}
