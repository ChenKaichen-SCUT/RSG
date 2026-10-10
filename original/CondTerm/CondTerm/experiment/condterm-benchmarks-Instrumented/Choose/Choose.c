#include <stdio.h>

int main() {
    int t;
    t = 3;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

    while (t >= 3) {
        printf("t:%d\n", t);
        if (t > 5) {
            t = t+3;
        } else {
            if (t > 10) {
                t = t-2;
            } else {
                t = t+1;
            }
        }
    }

    return 0;
}
