#include <assert.h>
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
    
  assert (((x <= -1) || (y <= -2) || (x + y <= -1)) && ((y <= -6) || (y > -5) || (x + y <= 9)) && ((y <= -5) || (y > -4) || (x + y <= 5)) && ((x <= -1) || (y <= -4) || (y > -2) || (x + y <= 2)) && ((x <= -1) || (y <= -5) || (y > -4) || (x <= -y) || (x + y <= 5)) && ((x <= -1) || (y <= -4) || (y > -3) || (x <= -y) || (x + y <= 2)) && ((x <= -1) || (y <= -3) || (y > -2) || (x <= -y) || (x + y <= -1)) && ((x <= -1) || (y <= -3) || (y > -2) || (x <= -y) || (x + y <= -1) || (x + y > 2)) && (((x <= -1) && (x <= 0)) || ((x <= -1) && (y <= -2)) || ((x <= -1) && (x <= -y)) || ((y <= -3) && (y <= -2) && (y <= -1)) || ((x <= 0) && (y <= -1) && (x + y <= -1)) || ((y <= -2) && (y <= -1) && (x <= -y)) || ((y <= -2) && (y <= -1) && (x + y <= -1)) || ((y <= -1) && (x <= -y) && (x + y <= -1)))); // CondTerm
	while (x >= 0) {
		printf("%d,%d\n", x, y);
		
		x = x + y;
		y = y + 1;
	}
	return 0;
}
