#include <stdio.h>

int main() {
    int t;
    int w;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    w = 5;
    
    while (t != 0) {
        printf("t:%d,w:%d\n", t, w);
        if (t < -w) {
            t = t-1;
            t = t*(-1);
        } else {
            if (t > w) {
                t = t+1;
                t = t*(-1);
            } else {
                t = 0;
            }
        }
        w = w+1;
    }

    return 0;
}
