#include <stdio.h>
#include <stdlib.h>

int main() {
    int a;
    int b;
    int r;
    scanf("%d%d", &a, &b);
  printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (b > 0) {
        printf("%d,%d\n", a, b);
        r =  rand();
        b = a - 1 - r;
        a = a - 1 - r;
    }
    
    return 0;
}