#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert ((t <= 5) && (t > -6)); // CondTerm
    while (t != 0) {
        printf("%d\n", t);
        if (t > 5) {
            printf("L1\n");
            t = t+1;
        } else {
            printf("L2\n");
            if (t < -5) {
                printf("L3\n");
                t = t-1;
            } else {
                printf("L4\n");
                t = 0;
            }
        }
    }

    return 0;
}
