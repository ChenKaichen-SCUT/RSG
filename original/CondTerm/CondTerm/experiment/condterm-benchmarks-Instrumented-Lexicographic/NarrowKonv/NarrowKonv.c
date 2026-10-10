#include <stdio.h>

int main() {
    int t;
    int range;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    range = 20;
    
    while (0 <= t && t <= range) {
        printf("%d\n", t);
        if (!(0 == t && t == range)) {
            printf("L1\n");
            if (t == range) {
                printf("L2\n");
                t = 0;
                range = range-1;
            } else {
                printf("L3\n");
                t = t+1;
            }
        }
    }
    
    return 0;
}
