#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int j;
    j = 100;
    t = 0;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (j - t < 100); // CondTerm
    while (t < j) {
        printf("#\n");
        j = j+1;
        t = t+1;
    }
    
    return 0;
}