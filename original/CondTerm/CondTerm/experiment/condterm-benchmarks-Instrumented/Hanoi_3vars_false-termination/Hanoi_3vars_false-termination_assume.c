#include <assert.h>
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
  assert (((x <= 0) || (z <= -2) || (y + z <= 1) || (y - z <= -4)) && ((x <= 0) || (y <= -2) || (z <= -1) || (x + z <= 3) || (y - z <= -4)) && ((x <= 0) || (y <= -1) || ((z <= -2) && (z <= -1)) || ((z <= -1) && (y + z <= -1))) && ((x <= 0) || (x <= z) || (z <= 0) || (y + z > 1) || (x - z <= -1) || (y - z <= -3)) && ((x <= 0) || (x <= z) || (z <= -3) || (z > 0) || (y + z <= -1) || (y + z > 1) || (x - z <= 1) || (y - z <= -3)) && ((x <= 2) || (x <= z) || (z <= -3) || (y > 0) || (z > 0) || (y + z <= -2) || (y + z > -1) || (x - z <= 1) || (y - z <= -3))); // CondTerm
    while (x > 0) {
        printf("x:%d,y:%d,z:%d\n", x, y, z);
        x = x + y;
        y = y + z;
        z = z + 1;
    }
    return 0;
}
