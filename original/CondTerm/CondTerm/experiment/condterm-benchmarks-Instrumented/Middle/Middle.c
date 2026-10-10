#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d%d", &t, &j);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t != j) {
        printf("t:%d,j:%d\n", t, j);
        t = t-1;
        j = j+1;
    }
    
    return 0;
}
