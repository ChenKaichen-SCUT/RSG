#include <stdio.h>
#include <stdlib.h>

int main() {
    int a;
    int b;
    int c;
    int r;
    scanf("%d%d%d", &b, &c, &a);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while ( (b - c >= 1) && (a == c)) {
        printf("b:%d,c:%d,a:%d,r:%d\n", b, c, a, r);
        r = rand();
        b = 10;
        c = c + 1 + r;
        a = c;
    }
    
    return 0;
}
