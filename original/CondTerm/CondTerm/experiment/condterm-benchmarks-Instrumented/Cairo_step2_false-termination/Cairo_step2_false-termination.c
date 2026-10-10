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
	    while (x != 0) {
			printf("x:%d\n", x);
	    	x = x - 2;
    	}
	}
	return 0;
}
