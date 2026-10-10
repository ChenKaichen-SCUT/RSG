#include <stdio.h>

int main() {
    int t;
    int range;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    range = 20;
    
    while (-range <= t && t <= range) {
        printf("%d\n", t);
        if (range-t < 5 || range+t < 5) {
            printf("L1\n");
            t = t*(-1);
        } else {
            printf("L2\n");
            range = range+1;
            t = t-1;
            if (t == 0) {
                printf("L3\n");
                range = -1;
            }
        }
    }
    
    return 0;
}
