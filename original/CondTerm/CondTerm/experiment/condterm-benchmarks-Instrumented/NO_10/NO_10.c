#include <stdio.h>

int main() {
    int t;
    int j;
    j = 100;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t < j) {
        printf("t:%d,j:%d\n", t, j);
        j = j+1;
        t = t+1;
    }
    
    return 0;
}