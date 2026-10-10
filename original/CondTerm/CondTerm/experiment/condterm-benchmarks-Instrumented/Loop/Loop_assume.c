#include <assert.h>
#include <stdio.h>

int main() {
    int a;
    int b;
    int t;
    a = 5;
    b = 3;
    t = 0;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert (t > 0); // CondTerm
    while (t < 10) { 
        printf("t:%d\n", t);
        t = t + 0; 
    }
    
    return 0;
}