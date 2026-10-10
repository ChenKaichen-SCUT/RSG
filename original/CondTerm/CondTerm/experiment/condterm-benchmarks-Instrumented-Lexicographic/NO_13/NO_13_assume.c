#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int j;
    j = 100;
    t = 0;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (((j + t > 100) || (j - t < 87)) && ((j > 81) || (j - t >= 64) || (j - t < 61)) && ((j + t > 100) || (j - t >= 71) || (j - t < 64)) && ((j + t > 100) || (j - t >= 77) || (j - t < 71)) && ((j + t > 100) || (j - t >= 81) || (j - t < 77)) && ((j + t > 100) || (j - t >= 87) || (j - t < 81)) && ((j + t > 101) || (j - t >= 5) || (j - t < 1)) && ((j + t > 101) || (j - t >= 50) || (j - t < 5)) && ((j + t > 101) || (j - t >= 56) || (j - t < 50)) && ((j + t > 101) || (j - t >= 61) || (j - t < 56))); // CondTerm
    while (t < j) {
        printf("#\n");
        if (51 < j) { 
            printf("L1\n");
            t = t+1; j = j-1; }
        else { 
            printf("L2\n");
            t = t-1; j = j+1; }
    }
    
    return 0;
}