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
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	if (c < 0) {
    	while (x + c >= 0) {
			printf("%d,%d\n", x, c);
	    	x = x - c;
		    c = c - 1;
	    }
	}
	return 0;
}
