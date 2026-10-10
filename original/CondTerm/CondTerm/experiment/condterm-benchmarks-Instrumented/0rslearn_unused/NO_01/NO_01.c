#include <stdio.h>

int main() {
    int c;
    int t;
    c = (24*6)*6;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    if (c <= 10) {
        t = 0;
        while (t < 100) {
            t = t+1;
        }
    }
    else {
        if (c <= 50) {
            t = 0;
            while (t < 101) {
                t = t+1;
            }
        }
        if (c <= 100) {
            t = 0;
            while (t < 102) {
                t = t+1;
            }
        }
        else {
            t = 0;
            while (t < 103) {
                printf("t:%d\n", t);
                t = t+0;
            }
        }
    }
    
    return 0;
}
