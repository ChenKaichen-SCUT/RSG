#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int w;
    // scanf("%d", &t);
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    w = 5;
    
  assert ((t <= 5) && (t > -7) && (t > -6)); // CondTerm
    while (t != 0) {
        printf("t:%d,w:%d\n", t, w);
        if (t < -w) {
            t = t-1;
            t = t*(-1);
        } else {
            if (t > w) {
                t = t+1;
                t = t*(-1);
            } else {
                t = 0;
            }
        }
    }
    
    return 0;
}
