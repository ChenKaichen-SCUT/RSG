#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t < 10) {
        j = t;
        while (j > 0) {
            // printf("j:%d\n", j);
            printf("%d\n", t);
            j = j+1;
        }
        t = t+1;
    }
    
    return 0;
}
