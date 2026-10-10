#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert ((t <= 4) && (t > -5)); // CondTerm
    while (t != 0) {
        printf("t:%d\n", t);
        if (t > -5 && t < 5) {
            if (t < 0) {
                t = t+1;
            }
            if (t > 0) {
                t = t-1;
            }
        } 			
    }
	
    return 0;
}
