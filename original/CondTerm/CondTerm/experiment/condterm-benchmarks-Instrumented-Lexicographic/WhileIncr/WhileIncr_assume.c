#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (t <= 0); // CondTerm
    while (t > 0) {
        printf("%d\n", t);
        t = t+1;
    }
    
    return 0;
}
