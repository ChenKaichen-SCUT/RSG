#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert ((t <= 4) && (t > -5)); // CondTerm
    while (t != 0) {
        printf("%d\n", t);
        if (t > -5 && t < 5) {
            printf("L1\n");
            if (t < 0) {
                printf("L2\n");
                t = t+1;
            }
            if (t > 0) {
                printf("L3\n");
                t = t-1;
            }
        } 			
    }
	
    return 0;
}
