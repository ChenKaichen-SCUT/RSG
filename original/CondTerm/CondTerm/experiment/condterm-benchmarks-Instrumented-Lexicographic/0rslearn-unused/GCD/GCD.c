#include <stdio.h>

int main() {
    int x;
    int y;
    int tmp;
    int xtmp;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while(y != 0) {
        printf("%d,%d\n", x, y);
        tmp = y;
        xtmp = x;
        
        if(x <= 0 || y <= 0) {
            printf("L1\n");
            y = 0;
        } else {
            printf("L2\n");
            if (x == y) {
                printf("L3\n");
                y = 0;
            } else {
                printf("L4\n");
                while(xtmp>y) {
                    xtmp = xtmp - y;
                }
            }
        }
        
        y = xtmp;
        x = tmp;
    }
    
    return 0;
}

