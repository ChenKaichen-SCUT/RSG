/*
 * Date: 06/07/2015
 * Created by: Ton Chanh Le (chanhle@comp.nus.edu.sg)
 */

#include <stdio.h>

int main()
{
    int x, y, z;
    scanf("%d%d%d", &x, &y, &z);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    while (x > 0) {
        printf("x:%d,y:%d,z:%d\n", x, y, z);
        x = x + y;
        y = y + z;
        z = z + 1;
    }
    return 0;
}
