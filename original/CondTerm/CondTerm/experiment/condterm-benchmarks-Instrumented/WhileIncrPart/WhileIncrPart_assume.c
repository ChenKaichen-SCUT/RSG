#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert (t <= 3); // CondTerm
    while (t > 0) {
        printf("t:%d\n", t);
        if (t > 3) {
            t = t+1;
        } else {
            t = t-1;
        }
    }
    
    return 0;
}
