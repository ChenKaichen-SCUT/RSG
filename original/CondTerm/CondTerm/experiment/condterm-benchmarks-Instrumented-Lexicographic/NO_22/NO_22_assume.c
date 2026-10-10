#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    t = 0;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (t > 50); // CondTerm
    while (t < 100) {
        printf("#\n");
        if (t < 50) { 
            printf("L1\n");
            t = t+1; }
        else { 
            printf("L2\n");
            t = t-1; }
    }
    
    return 0;
}
