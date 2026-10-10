#include <stdio.h>

int main() {
    int t;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t < 100) {
        printf("t:%d\n", t);
        if (t < 50) { t = t+1; }
        else { t = t-1; }
    }
    
    return 0;
}
