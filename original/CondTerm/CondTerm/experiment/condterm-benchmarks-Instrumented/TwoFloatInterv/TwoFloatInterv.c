#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t > 0 && t < 50) {
        printf("t:%d\n", t);
        if (t < 20) {
            t = t-1;
        }
        if (t > 10) {
            t = t+1;
        }
        if (30 <= t && t <= 40) {
            t = t-1;
        }
        
    }
    
    return 0;
}
