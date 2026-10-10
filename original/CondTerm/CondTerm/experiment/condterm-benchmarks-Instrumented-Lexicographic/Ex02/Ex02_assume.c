#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (t <= 4); // CondTerm
    while (t > 0) {
        printf("%d\n", t);
        if (t != 5) {
            printf("L1\n");
            t = t-1;
        }
    }
    
    return 0;
}
