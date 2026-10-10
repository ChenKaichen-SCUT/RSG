/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 */

#include <stdio.h>

int main()
{
    int x;
    int y;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	if (y >= 0) {
	    while (x >= 0) {
			printf("%d,%d\n", x, y);
	    	x = x - y;
    	}
	}
	return 0;
}
