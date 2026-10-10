#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (t > 3); // CondTerm
    while (t < 10) {
        printf("%d\n", t);
        if (t != 3) {
            printf("L1\n");
            t = t+1;
        }
    }
    
    return 0;
}
