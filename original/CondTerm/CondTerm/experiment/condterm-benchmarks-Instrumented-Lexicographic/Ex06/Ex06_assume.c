#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert ((t <= -6) || ((t > 0) && (t > 1) && (t > 2) && (t > 3) && (t > 4) && (t > 5))); // CondTerm
    while (t >= -5 && t <= 5) {
        printf("%d\n", t);
        if (t > 0) {
            printf("L1\n");
            t = t-1;
        }
        if (t < 0) {
            printf("L2\n");
            t = t+1;
        }
    }
    
    return 0;
}
