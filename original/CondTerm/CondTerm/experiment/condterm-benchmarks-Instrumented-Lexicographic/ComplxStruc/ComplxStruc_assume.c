#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d", &t);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    j = t;
    
  assert (t <= 0); // CondTerm
    while (t > 0) {
        printf("%d\n", t);
        if (t >= j) {
            printf("L1\n");
            t = t+1;
            if (j < 5) {
                printf("L2\n");
                j = j+1;
                if (t-j>2) {
                    printf("L3\n");
                    t = t+1;
                } else {
                    printf("L4\n");
                    j = j+1;
                }
            } else {
                printf("L5\n");
                j = j-1;
            }
        } else {
            printf("L6\n");
            if (t > 0 && j < 0) {
                printf("L7\n");
                t = t-1;
                if (j < -1) {
                    printf("L8\n");
                    j = j+1;
                } else {
                    printf("L9\n");
                    t = t+1;
                }
            } else {
                printf("L10\n");
                t = t+1;
                if (j*2 > t) {
                    printf("L11\n");
                    j = j-1;
                } else {
                    printf("L12\n");
                    j = j+1;
                }
            }
        }
        
    }

    return 0;
}
