#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert ((t <= 24) || ((t > 29) && (t > 30))); // CondTerm
    while (t > 10) {
        printf("t:%d\n", t);
        if (t == 25) {
            t = 30;
        }
        if (t <= 30) {
            t = t-1;
        } else {
            t = 20;
        }
    }
    
    return 0;
}
