/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from Cairo_true-termination.c
 */

#include <stdio.h>
#include <stdlib.h>

int main()
{
    int x;
    scanf("%d", &x);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (x > rand()) {
    	while (x != 0) {
			printf("x:%d\n", x);
	    	x = x - 1;
    	}
	}
	return 0;
}
