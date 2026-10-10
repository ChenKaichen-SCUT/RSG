#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert ((t <= -6) || ((t > 0) && (t > 1) && (t > 2) && (t > 3) && (t > 4) && (t > 5))); // CondTerm
    while (t >= -5 && t <= 5) {
        printf("t:%d\n", t);
        if (t > 0) {
            t = t-1;
        }
        if (t < 0) {
            t = t+1;
        }
    }
    
    return 0;
}
