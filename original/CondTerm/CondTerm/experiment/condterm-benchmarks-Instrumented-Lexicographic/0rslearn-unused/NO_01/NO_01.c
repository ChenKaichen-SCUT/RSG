#include <stdio.h>

int main() {
    int c;
    int t;
    c = (24*6)*6;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
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
                printf("#\n");
                t = t+0;
            }
        }
    }
    
    return 0;
}
