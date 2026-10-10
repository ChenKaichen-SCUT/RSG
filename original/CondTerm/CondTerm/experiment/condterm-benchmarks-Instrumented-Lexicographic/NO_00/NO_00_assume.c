#include <assert.h>
#include <stdio.h>

int main() {
    int x;
    scanf("%d", &x);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert ((x > 0) && (x > 1) && (x > 2) && (x > 3) && (x > 4) && (x > 5) && (x > 6) && (x > 7) && (x > 8) && (x > 9) && (x > 10) && (x > 11) && (x > 12) && (x > 13) && (x > 14)); // CondTerm
    while (x < 100) {
        printf("%d\n", x);
        x = x+0;
    }

    return 0;
}
