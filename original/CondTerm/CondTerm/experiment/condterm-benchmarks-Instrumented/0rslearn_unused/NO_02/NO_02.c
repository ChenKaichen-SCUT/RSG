#include <stdio.h>

int main() {
    int t;
    int j;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t < 100) {
        j = 0;
        while (j < 1) {
            printf("j:%d\n", j);
            j = j+0;
        }
        t = t+1;
    }
    
    return 0;
}
