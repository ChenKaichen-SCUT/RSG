#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d%d", &t, &j);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (false); // CondTerm
    while (1) {
        printf("%d,%d\n", t, j);
        if (t < j) {
            printf("L1\n");
            t = t+4;
        } else {
            printf("L2\n");
            j = j+1;
            t = t+2;
        }
    }
	
    return 0;
}
