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
  assert (((x <= 0) || (x <= -y) || (y + z <= -1)) && ((x <= 0) || (x + y <= 1) || (y + z <= -1)) && ((x <= 0) || (x + y <= 2) || (x - z > 3)) && ((x <= 1) || (x <= -y) || (x + y <= 1) || (y + z <= -1)) && ((x <= 1) || (y <= -z) || (x + y <= 5) || (y + z <= -3)) && ((x <= 1) || (x <= y) || (x + y <= 7) || (y + z <= -3) || (y > -z)) && ((x <= 1) || (x <= -y) || (x + y <= 2) || (y + z <= -2) || (y + z > -1)) && ((x <= 0) || (x <= -y) || (x <= -z) || (x + y <= 1) || (y + z <= -2) || (y + z > -1)) && ((x <= 0) || ((y <= -1) && (x <= -y)) || ((z <= -1) && (x <= -y)) || ((y <= -1) && (y <= -z) && (x + z <= 2)) || ((y <= -1) && (y <= -z) && (y + z <= -1)) || ((z <= -1) && (y <= -z) && (x + z <= 2)) || ((z <= -1) && (y <= -z) && (y + z <= -1)))); // CondTerm
    while (x > 0) {
        printf("x:%d,y:%d,z:%d\n", x, y, z);
        x = x + y;
        y = y + z;
        z = z + x;
    }
    return 0;
}
