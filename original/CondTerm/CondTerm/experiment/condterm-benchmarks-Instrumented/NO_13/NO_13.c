#include <stdio.h>

int main() {
    int t;
    int j;
    j = 100;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t < j) {
        printf("t:%d,j:%d\n", t, j);
        if (51 < j) { t = t+1; j = j-1; }
        else { t = t-1; j = j+1; }
    }
    
    return 0;
}