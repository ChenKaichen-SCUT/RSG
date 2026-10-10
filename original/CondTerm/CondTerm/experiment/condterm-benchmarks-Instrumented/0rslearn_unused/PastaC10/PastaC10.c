#include <stdio.h>
#include <stdlib.h>

int main() {
    int t;
    int j;
    int r, tmp;
    scanf("%d%d", &t, &j);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t - j >= 1) {
        printf("t:%d,j:%d,tmp:%d\n", t, j, tmp);
        tmp = rand();
        t = t - tmp;
        tmp = rand();
        r = tmp + 1;
        j = j + r;
    }
    
    return 0;
}
