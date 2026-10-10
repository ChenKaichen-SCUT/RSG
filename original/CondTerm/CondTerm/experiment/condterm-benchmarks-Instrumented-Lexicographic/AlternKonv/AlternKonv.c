#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t != 0) {
        printf("%d\n", t);
        if (t < 0) {
            printf("L1\n");
            t = t+2;
            if (t < 0) {
                printf("L2\n");
                t = t*(-1);
            }
        } else {
            printf("L3\n");
            t = t-2;
            if (t > 0) {
                printf("L4\n");
                t = t*(-1);
            }
        }
    }
    
    return 0;
}
