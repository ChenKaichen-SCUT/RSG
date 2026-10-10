/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from Mysore_true-termination.c
 */

#include <stdio.h>

int main()
{
	int x;
	int c;
    scanf("%d%d", &x, &c);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (c < 0) {
    	while (x + c >= 0) {
			printf("x:%d,c:%d\n", x, c);
	    	x = x - c;
		    c = c - 1;
	    }
	}
	return 0;
}
