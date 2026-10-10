#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int up;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    up = 0;
    
  assert (t <= 0); // CondTerm
    while (t > 0) {
        printf("%d\n", t);
        if (t == 1) {
            printf("L1\n");
            up = 1;
        }
        if (t == 10) {
            printf("L2\n");
            up = 0;
        }
        if (up == 1) {
            printf("L3\n");
            t = t+1;
        } else {
            printf("L4\n");
            t = t-1;
        }
    }
    
    return 0;
}
