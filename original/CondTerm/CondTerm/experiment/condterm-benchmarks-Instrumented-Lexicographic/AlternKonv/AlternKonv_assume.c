#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (((t <= -16) || (t > -15)) && ((t <= -14) || (t > -13)) && ((t <= -12) || (t > -11)) && ((t <= -10) || (t > -9)) && ((t <= -8) || (t > -7)) && ((t <= -6) || (t > -5)) && ((t <= -4) || (t > -3)) && ((t <= -2) || (t > -1)) && ((t <= 0) || (t > 1)) && ((t <= 2) || (t > 3)) && ((t <= 4) || (t > 5)) && ((t <= 6) || (t > 7)) && ((t <= 8) || (t > 9)) && ((t <= 10) || (t > 11)) && ((t <= 12) || (t > 13)) && ((t <= 14) || (t > 15)) && ((t <= 16) || (t > 17))); // CondTerm
    while (t != 0) {
        printf("%d\n", t);
        if (t < 0) {
            printf("L1\n");
            t = t+2;
            if (t < 0) {
                printf("L2\n");
                t = t*(-1);
            }
        } else {
            printf("L3\n");
            t = t-2;
            if (t > 0) {
                printf("L4\n");
                t = t*(-1);
            }
        }
    }
    
    return 0;
}
