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
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
  assert (((x <= -6) && (x <= 30)) || ((x <= -6) && (x > 35)) || ((x <= 30) && (x > -1)) || ((x > -1) && (x > 35))); // CondTerm
	while (x!=0) {
		printf("x:%d\n", x);
	    if (-5 <= x && x <= 35) {
		    if (x < 0) {
			    x = -5;
			} else {
			    if (x > 30) {
				    x = 35;
				} else {
					x = x - 1;
				}
			}
		} else {
		    x = 0;
		}
	}
    return 0;
}
