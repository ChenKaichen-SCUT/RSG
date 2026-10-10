#include <assert.h>
#include <stdio.h>
// #include <assert.h>

int main() {
    int t;
    int w;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    // w = 5;
    // assert (w >= 0);
    
  assert (((t > -1) || (w != 0)) && ((t < 1) || (w != 0)) && ((w > 1) || (t + w < 3)) && ((w > 1) || (t - w > -3))); // CondTerm
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
