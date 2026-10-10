/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 */

#include <stdio.h>

int main()
{
    int x, y, z;
    scanf("%d%d%d", &x, &y, &z);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    while (x > 0) {
        printf("%d,%d,%d\n", x, y, z);
        x = x + y;
        y = y + z;
        z = z + x;
    }
    return 0;
}
