#include <stdio.h>

int main()
{
    int x;
    int y;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    while (x > 0) {
        printf("%d,%d\n", x, y);
        x = x + y;
        y = y + 1;
    }
    return 0;
}
