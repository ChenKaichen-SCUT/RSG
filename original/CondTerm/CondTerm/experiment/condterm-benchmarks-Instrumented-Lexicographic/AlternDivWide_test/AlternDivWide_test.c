#include <stdio.h>
#include <assert.h>

int main() {
    int t;
    int w;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    // w = 5;
    // assert (w >= 0);
    
    while (t != 0) {
        printf("%d\n", t);
        if (t < -w) {
            printf("L1\n");
            t = t-1;
            t = t*(-1);
        } else {
            printf("L2\n");
            if (t > w) {
                printf("L3\n");
                t = t+1;
                t = t*(-1);
            } else {
                printf("L4\n");
                t = 0;
            }
        }
    }
    
    return 0;
}
