#include <assert.h>
#include <stdio.h>

int main() {
    int a;
    int b;
    a = 1;
    b = 2;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (a + b > 3); // CondTerm
    while (a + b < 5) {
        printf("#\n");
        a = a - b;
        b = a + b;
        a = b - a;
    }
    
    return 0;
}
