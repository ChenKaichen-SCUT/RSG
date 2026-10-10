#include <assert.h>
#include <stdio.h>

int main()
{
    int x;
    int y;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
  assert ((x < 1) || ((y < -1) && (y < 0)) || ((y < 0) && (x + y < 1))); // CondTerm
    while (x > 0) {
        printf("%d,%d\n", x, y);
        x = x + y;
        y = y + 1;
    }
    return 0;
}
