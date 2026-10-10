#include <stdio.h>
#include <stdlib.h>

int main() {
    int a;
    int b;
    int c;
    int r;
    scanf("%d%d%d", &b, &c, &a);
  printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while ( (b - c >= 1) && (a == c)) {
        printf("%d,%d,%d\n", b, c, a);
        r = rand();
        b = 10;
        c = c + 1 + r;
        a = c;
    }
    
    return 0;
}
