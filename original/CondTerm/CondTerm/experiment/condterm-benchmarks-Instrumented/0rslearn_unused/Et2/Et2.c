#include <stdio.h>
#include <stdlib.h>

int main() {
    int a;
    int b;
    int r;
    scanf("%d%d", &a, &b);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (b > 0) {
        printf("a:%d,b:%d,r:%d\n", a, b, r);
        r =  rand();
        b = a - 1 - r;
        a = a - 1 - r;
    }
    
    return 0;
}