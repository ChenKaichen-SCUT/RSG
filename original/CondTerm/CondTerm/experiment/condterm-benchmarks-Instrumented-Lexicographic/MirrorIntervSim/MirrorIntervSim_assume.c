#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (((t <= -6) && (t <= 30)) || ((t <= -6) && (t > 35)) || ((t <= 30) && (t > -1)) || ((t > -1) && (t > 35))); // CondTerm
    while (t != 0) {
        printf("%d\n", t);
        if (-5 <= t && t <= 35) {
            printf("L1\n");
            if (t < 0) {
                printf("L2\n");
                t = -5;
            } else {
                printf("L3\n");
                if (t > 30) {
                    printf("L4\n");
                    t = 35;
                } else {
                    printf("L5\n");
                    t = t-1;
                }	
            }					
        } else {
            printf("L6\n");
            t = 0;
        }
    }
    
    return 0;
}
