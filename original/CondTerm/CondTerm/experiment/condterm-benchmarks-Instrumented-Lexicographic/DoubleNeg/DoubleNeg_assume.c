#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d%d", &t, &j);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert ((j > -1) || (t > -1)); // CondTerm
    while (t*j > 0) {
        printf("%d,%d\n", t, j);
        t = t - 1;
        j = j - 1;
    }
    
    return 0;
}
