#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t != 0) {
        printf("t:%d\n", t);
        if (t < 0) {
            t = t-1;
            t = t*(-1);
        } else {
            t = t+1;
            t = t*(-1);
        }
    }

    return 0;
}
