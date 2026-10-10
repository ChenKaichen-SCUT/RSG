#include <assert.h>
#include <stdio.h>

int main() {
    int x;
    int y;
    int z;
    int res;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    z = y;
    res = 0;
    
  assert ((x <= 0) || (y <= -1) || ((z <= 0) && (z <= 1))); // CondTerm
    while (z > 0 && (y == 0 || y > 0 && x > 0))	{
        printf("%d,%d\n", x, y);
        
        if (y == 0) {
            printf("L1\n");
            res = res + 1;
            y = z;
        }
        else {
            printf("L2\n");
            x = x + 1;
            y = y - 1;
        }
    }
    
    return 0;
}

