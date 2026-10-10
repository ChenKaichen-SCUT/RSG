#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t > 0 && t < 50) {
        printf("%d\n", t);
        if (t < 20) {
            printf("L1\n");
            t = t-1;
        }
        if (t > 10) {
            printf("L2\n");
            t = t+1;
        }
        if (30 <= t && t <= 40) {
            printf("L3\n");
            t = t-1;
        }
        
    }
    
    return 0;
}
