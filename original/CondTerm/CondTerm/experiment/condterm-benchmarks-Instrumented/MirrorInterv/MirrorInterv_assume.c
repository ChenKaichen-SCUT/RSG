#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int range;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    range = 20;
    
  assert (((range <= 19) || (range + t <= -1) || (range + t > 10)) && ((range <= 19) || (range < t) || (range + t <= 10) || (range - t >= 5)) && (((range <= 19) && (t > -3)) || ((t > -3) && (t > 0)) || ((range <= 19) && (range + t <= 6)) || ((t > -3) && (range + t <= 9)) || ((t > 0) && (range + t <= 6)) || ((range + t <= 6) && (range + t <= 9)))); // CondTerm
    while (-range <= t && t <= range) {
        printf("t:%d,range:%d\n", t, range);
        if (range-t < 5 || range+t < 5) {
            t = t*(-1);
        } else {
            range = range+1;
            t = t-1;
            if (t == 0) {
                range = -1;
            }
        }
    }
    
    return 0;
}
