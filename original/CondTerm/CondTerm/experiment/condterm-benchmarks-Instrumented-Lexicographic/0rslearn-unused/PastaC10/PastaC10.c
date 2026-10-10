#include <stdio.h>
#include <stdlib.h>

int main() {
    int t;
    int j;
    int r, tmp;
    scanf("%d%d", &t, &j);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t - j >= 1) {
        printf("%d,%d\n", t, j);
        tmp = rand();
        t = t - tmp;
        tmp = rand();
        r = tmp + 1;
        j = j + r;
    }
    
    return 0;
}
