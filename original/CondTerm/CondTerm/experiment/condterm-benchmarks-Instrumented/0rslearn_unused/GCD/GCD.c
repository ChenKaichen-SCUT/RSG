#include <stdio.h>

int main() {
    int x;
    int y;
    int tmp;
    int xtmp;
    scanf("%d%d", &x, &y);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while(y != 0) {
        printf("x:%d,y:%d\n", x, y);
        tmp = y;
        xtmp = x;
        
        if(x <= 0 || y <= 0) {
            y = 0;
        } else {
            if (x == y) {
                y = 0;
            } else {
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

