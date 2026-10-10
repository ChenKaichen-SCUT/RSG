#include <stdio.h>

int main() {
    int x;
    scanf("%d", &x);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (x < 100) {
        printf("x:%d\n", x);
        x = x+0;
    }

    return 0;
}
