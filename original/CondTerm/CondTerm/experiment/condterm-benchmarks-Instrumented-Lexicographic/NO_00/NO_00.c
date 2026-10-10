#include <stdio.h>

int main() {
    int x;
    scanf("%d", &x);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (x < 100) {
        printf("%d\n", x);
        x = x+0;
    }

    return 0;
}
