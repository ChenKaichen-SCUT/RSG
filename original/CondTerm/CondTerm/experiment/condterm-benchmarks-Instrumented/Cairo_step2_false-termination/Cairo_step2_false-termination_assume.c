#include <assert.h>
/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from Cairo_true-termination.c
 */

#include <stdio.h>

int main()
{
    int x;
    scanf("%d", &x);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (x > 0) {
  assert ((x > -1) && ((x <= 0) || (x > 1)) && ((x <= 2) || (x > 3)) && ((x <= 4) || (x > 5)) && ((x <= 6) || (x > 7)) && ((x <= 8) || (x > 9)) && ((x <= 10) || (x > 11)) && ((x <= 12) || (x > 13)) && ((x <= 14) || (x > 15)) && ((x <= 16) || (x > 17)) && ((x <= 18) || (x > 19)) && ((x <= 20) || (x > 21)) && ((x <= 22) || (x > 23)) && ((x <= 24) || (x > 25)) && ((x <= 26) || (x > 27)) && ((x <= 28) || (x > 29))); // CondTerm
	    while (x != 0) {
			printf("x:%d\n", x);
	    	x = x - 2;
    	}
	}
	return 0;
}
