#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d%d", &t, &j);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert ((j - t < 1) && ((j <= -t) || (j + t > 1)) && ((j + t <= -8) || (j + t > -7)) && ((j + t <= -6) || (j + t > -5)) && ((j + t <= -4) || (j + t > -3)) && ((j + t <= -2) || (j + t > -1)) && ((j + t <= 2) || (j + t > 3)) && ((j + t <= 4) || (j + t > 5)) && ((j + t <= 6) || (j + t > 7)) && ((j + t <= 8) || (j + t > 9)) && ((j + t <= 10) || (j + t > 11)) && ((j + t <= 14) || (j + t > 15)) && ((j + t <= 16) || (j + t > 17)) && ((j + t <= 18) || (j + t > 19)) && ((j >= t) || (t > -2) || (j - t >= 1) || (j - t < -1))); // CondTerm
    while (t != j) {
        printf("t:%d,j:%d\n", t, j);
        t = t-1;
        j = j+1;
    }
    
    return 0;
}
