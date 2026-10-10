#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    j = t;
    
    while (t > 0) {
        printf("t:%d,j:%d\n", t, j);
        if (t >= j) {
            t = t+1;
            if (j < 5) {
                j = j+1;
                if (t-j>2) {
                    t = t+1;
                } else {
                    j = j+1;
                }
            } else {
                j = j-1;
            }
        } else {
            if (t > 0 && j < 0) {
                t = t-1;
                if (j < -1) {
                    j = j+1;
                } else {
                    t = t+1;
                }
            } else {
                t = t+1;
                if (j*2 > t) {
                    j = j-1;
                } else {
                    j = j+1;
                }
            }
        }
        
    }

    return 0;
}
