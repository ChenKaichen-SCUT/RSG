#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t > 2) {
        printf("%d\n", t);

        t = t+1;
    }
    
    return 0;
}