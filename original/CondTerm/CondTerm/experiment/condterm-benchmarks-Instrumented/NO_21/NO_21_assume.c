#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert (t > 0); // CondTerm
    while (t < 100) {
        printf("t:%d\n", t);
        t = t+1;
        t = t-1;
    }
    
    return 0;
}
