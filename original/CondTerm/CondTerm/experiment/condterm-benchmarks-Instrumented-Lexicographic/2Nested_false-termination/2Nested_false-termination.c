/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 * Adapted from the example 2Nested_true-termination.c
 *
 * This program does not terminate when x >= 0 & y >= 0
 */

#include <stdio.h>

int main()
{
    int x;
    int y;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
	while (x >= 0) {
		printf("%d,%d\n", x, y);
		
		x = x + y;
		y = y + 1;
	}
	return 0;
}
