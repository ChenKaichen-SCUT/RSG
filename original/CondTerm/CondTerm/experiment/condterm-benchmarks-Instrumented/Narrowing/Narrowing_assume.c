#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int range;
    int up;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

    range = 20;
    up = 0;
    
  assert (((up <= -1) && (range < t)) || ((range <= 0) && (t - up <= -1)) || ((t <= -1) && (t - up <= -1)) || ((range < t) && (t - up <= -1)) || ((range < t) && (range - t < 1)) || ((range <= 0) && (up <= -1) && (range - t >= 1)) || ((range <= 0) && (up <= 0) && (range - t < 1)) || ((t <= -1) && (up <= -1) && (range - t >= 1)) || ((t <= -1) && (up <= 0) && (range - t < 1))); // CondTerm
    while (0 <= t && t <= range) {
        printf("t:%d,range:%d,up:%d\n", t, range, up);
        if (t == 0) {
            up = 1;
        }
        if (t == range) {
            up = 0;
        }
        if (up == 1) {
            t = t+1;
        }
        if (up == 0) {
            t = t-1;
        }
        if (t == range-2) {
            range = range-1;
        }
    }
    
    return 0;
}
