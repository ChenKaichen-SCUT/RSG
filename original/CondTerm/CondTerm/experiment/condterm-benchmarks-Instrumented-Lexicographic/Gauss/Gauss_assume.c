#include <assert.h>
#include <stdio.h>

int main() {
    int n;
    int sum;
    scanf("%d", &n);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    sum = 0;
    
  assert (n > -1); // CondTerm
    while (n != 0) {
        printf("%d\n", n);
        sum = sum + n;
        n = n - 1;
    }

    return 0;
}
