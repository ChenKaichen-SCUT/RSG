#include <assert.h>
/*
 * Program from Fig.1 of
 * 2005CAV - Bradley,Manna,Sipma - Linear Ranking with Reachability
 * Modified version that can be nonterminating because we allow that inputs of
 * gcd may be zero.
 *
 * Date: 12.12.2013
 * Author: heizmann@informatik.uni-freiburg.de
 *
 */

#include <stdio.h>

int main() {
    int y1, y2;
	scanf("%d%d", &y1, &y2);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (y1 >= 0 && y2 >= 0) {
  assert (((y1 <= 0) && (y2 <= 0)) || ((y1 > 0) && (y2 > 0))); // CondTerm
    	while (y1 != y2) {
			printf("y1:%d,y2:%d\n", y1, y2);
	    	if (y1 > y2) {
		    	y1 = y1 - y2;
    		} else {
	    		y2 = y2 - y1;
		    }
	    }
	}
	return 0;
}
