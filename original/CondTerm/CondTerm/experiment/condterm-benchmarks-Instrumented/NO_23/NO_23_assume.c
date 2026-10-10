#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert (t > 51); // CondTerm
    while (t < 100) {
        printf("t:%d\n", t);
        if (t < 50) { t = 51; }
        else { t = 49; }
    }
    
    return 0;
}
