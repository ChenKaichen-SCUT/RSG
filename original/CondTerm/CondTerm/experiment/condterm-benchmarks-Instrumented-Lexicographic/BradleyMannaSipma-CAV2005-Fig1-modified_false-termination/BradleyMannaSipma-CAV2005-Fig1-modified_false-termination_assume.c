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
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	if (y1 >= 0 && y2 >= 0) {
  assert (((y1 <= 0) && (y2 <= 0)) || ((y1 > 0) && (y2 > 0))); // CondTerm
    	while (y1 != y2) {
			printf("%d,%d\n", y1, y2);
	    	if (y1 > y2) {
				printf("L1\n");
		    	y1 = y1 - y2;
    		} else {
				printf("L2\n");
	    		y2 = y2 - y1;
		    }
	    }
	}
	return 0;
}
