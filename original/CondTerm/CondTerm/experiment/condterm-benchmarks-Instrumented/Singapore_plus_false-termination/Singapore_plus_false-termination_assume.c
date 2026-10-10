#include <assert.h>
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
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    if (x + y >= 0) { 
  assert ((x <= 0) || ((x <= -y) && (x + y <= -1))); // CondTerm
        while (x > 0) {
            printf("x:%d,y:%d\n", x, y);
            x = x + x + y;
            y = y + 1;
        }
    }
    return 0;
}
