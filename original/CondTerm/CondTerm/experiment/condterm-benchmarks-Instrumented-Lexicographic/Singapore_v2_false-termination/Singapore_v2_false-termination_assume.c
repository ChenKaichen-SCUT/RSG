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
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    if (x + y > 1) {
  assert ((x <= 0) || (x + y <= 1)); // CondTerm
        while (x > 0) {
            printf("%d,%d\n", x, y);
            x = x + x + y;
            y = y - 1;
        }
    }
    return 0;
}
