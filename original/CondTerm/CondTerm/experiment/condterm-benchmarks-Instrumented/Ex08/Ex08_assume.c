#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int up;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    up = 0;
    
  assert (t <= 0); // CondTerm
    while (t > 0) {
        printf("t:%d\n", t);
        if (t == 1) {
            up = 1;
        }
        if (t == 10) {
            up = 0;
        }
        if (up == 1) {
            t = t+1;
        } else {
            t = t-1;
        }
    }
    
    return 0;
}
