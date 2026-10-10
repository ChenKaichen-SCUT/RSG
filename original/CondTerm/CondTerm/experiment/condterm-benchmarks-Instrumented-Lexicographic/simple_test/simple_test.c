#include <stdio.h>

int main()
{
    int x, y;
    scanf("%d", &x);
    scanf("%d", &y);
    
    while (x >= 0)
    {
        printf("x:%d,y:%d\n", x, y);
        x = x + y;
    }
    return 0;
}
