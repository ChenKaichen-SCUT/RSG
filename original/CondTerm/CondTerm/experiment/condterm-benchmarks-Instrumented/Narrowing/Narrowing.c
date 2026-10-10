#include <stdio.h>

int main() {
    int t;
    int range;
    int up;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

    range = 20;
    up = 0;
    
    while (0 <= t && t <= range) {
        printf("t:%d,range:%d,up:%d\n", t, range, up);
        if (t == 0) {
            up = 1;
        }
        if (t == range) {
            up = 0;
        }
        if (up == 1) {
            t = t+1;
        }
        if (up == 0) {
            t = t-1;
        }
        if (t == range-2) {
            range = range-1;
        }
    }
    
    return 0;
}
