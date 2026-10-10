#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    t = 0;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (t > 0); // CondTerm
    while (t < 100) {
        printf("#\n");
        t = t+1;
        t = t-1;
    }
    
    return 0;
}
