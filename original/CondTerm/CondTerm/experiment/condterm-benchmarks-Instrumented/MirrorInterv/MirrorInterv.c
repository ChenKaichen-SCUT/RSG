#include <stdio.h>

int main() {
    int t;
    int range;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    range = 20;
    
    while (-range <= t && t <= range) {
        printf("t:%d,range:%d\n", t, range);
        if (range-t < 5 || range+t < 5) {
            t = t*(-1);
        } else {
            range = range+1;
            t = t-1;
            if (t == 0) {
                range = -1;
            }
        }
    }
    
    return 0;
}
