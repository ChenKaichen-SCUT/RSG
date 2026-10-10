#include <stdio.h>

int main() {
    int t;
    int range;
    int up;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");

    range = 20;
    up = 0;
    
    while (0 <= t && t <= range) {
        printf("%d\n", t);
        if (t == 0) {
            printf("L1\n");
            up = 1;
        }
        if (t == range) {
            printf("L2\n");
            up = 0;
        }
        if (up == 1) {
            printf("L3\n");
            t = t+1;
        }
        if (up == 0) {
            printf("L4\n");
            t = t-1;
        }
        if (t == range-2) {
            printf("L5\n");
            range = range-1;
        }
    }
    
    return 0;
}
