#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int range;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    range = 20;
    
  assert ((t <= -1) || (range < t)); // CondTerm
    while (0 <= t && t <= range) {
        printf("t:%d,range:%d\n", t, range);
        if (!(0 == t && t == range)) {
            if (t == range) {
                t = 0;
                range = range-1;
            } else {
                t = t+1;
            }
        }
    }
    
    return 0;
}
