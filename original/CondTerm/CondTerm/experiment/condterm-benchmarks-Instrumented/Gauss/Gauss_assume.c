#include <assert.h>
#include <stdio.h>

int main() {
    int n;
    int sum;
    scanf("%d", &n);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    sum = 0;
    
  assert (n > -1); // CondTerm
    while (n != 0) {
        printf("n:%d\n", n);
        sum = sum + n;
        n = n - 1;
    }

    return 0;
}
