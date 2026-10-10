#include <stdio.h>

int main() {
    int t;
    int j;
    int k;
    int l;
    int m;
    int a;
    int b;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t < 100) {
        a = t+2;
        j = 0;
        while (j < a) {
            k = t+j+3;
            while (k >= 0) {
                b = t+j+k+4;
                l = 0;
                while (l < b) {
                    m = t+j+k+l+1000;
                    while (m >= 0) {
                        printf("m:%d\n", m);
                        m = m-0;
                    }
                    l = l+1;
                }
                k = k-1;
            }
            j = j+1;
        }
        t = t+1;
    }
    
    return 0;
}
