#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t != 0) {
        printf("t:%d\n", t);
        if (-5 <= t && t <= 35) {
            if (t < 0) {
                t = -5;
            } else {
                if (t > 30) {
                    t = 35;
                } else {
                    t = t-1;
                }	
            }					
        } else {
            t = 0;
        }
    }
    
    return 0;
}
