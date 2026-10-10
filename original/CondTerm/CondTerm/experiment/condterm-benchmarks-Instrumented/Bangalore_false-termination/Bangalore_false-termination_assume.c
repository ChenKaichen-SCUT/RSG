#include <assert.h>
/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from the example Bangalore_true-termination.c
 */

#include <stdio.h>

int main()
{
    int x;
    int y;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (y < 1) {
  assert (x <= -1); // CondTerm
	    while (x >= 0) {
			printf("x:%d,y:%d\n", x, y);
	    	x = x - y;
    	}
	}
	return 0;
}
