#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int j;
    j = 100;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert (((j + t > 100) || (j - t < 87)) && ((j > 81) || (j - t >= 64) || (j - t < 61)) && ((j + t > 100) || (j - t >= 71) || (j - t < 64)) && ((j + t > 100) || (j - t >= 77) || (j - t < 71)) && ((j + t > 100) || (j - t >= 81) || (j - t < 77)) && ((j + t > 100) || (j - t >= 87) || (j - t < 81)) && ((j + t > 101) || (j - t >= 5) || (j - t < 1)) && ((j + t > 101) || (j - t >= 50) || (j - t < 5)) && ((j + t > 101) || (j - t >= 56) || (j - t < 50)) && ((j + t > 101) || (j - t >= 61) || (j - t < 56))); // CondTerm
    while (t < j) {
        printf("t:%d,j:%d\n", t, j);
        if (51 < j) { t = t+1; j = j-1; }
        else { t = t-1; j = j+1; }
    }
    
    return 0;
}