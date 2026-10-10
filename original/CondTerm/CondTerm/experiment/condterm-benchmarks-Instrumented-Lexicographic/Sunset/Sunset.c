#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t > 10) {
        printf("%d\n", t);
        if (t == 25) {
            printf("L1\n");
            t = 30;
        }
        if (t <= 30) {
            printf("L2\n");
            t = t-1;
        } else {
            printf("L3\n");
            t = 20;
        }
    }
    
    return 0;
}
