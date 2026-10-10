#include <stdio.h>

int main() {
    int t;
    int up;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    up = 0;
    
    while (0 <= t && t <= 10) {
        printf("t:%d,up:%d\n", t, up);
        if (t >= 10) {
            up = 0;
        }
        if (t <= 0) {
            up = 1;
        }
        if (up >= 1) {
            t = t+1;
        } else {
            t = t-1;
        }
    }
    
    return 0;
}
