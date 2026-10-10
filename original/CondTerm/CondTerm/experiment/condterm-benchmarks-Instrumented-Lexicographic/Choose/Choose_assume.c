#include <assert.h>
#include <stdio.h>

int main() {
    int t;
    t = 3;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");

  assert (t <= 2); // CondTerm
    while (t >= 3) {
        printf("#\n");
        if (t > 5) {
            printf("L1\n");
            t = t+3;
        } else {
            printf("L2\n");
            if (t > 10) {
                printf("L3\n");
                t = t-2;
            } else {
                printf("L4\n");
                t = t+1;
            }
        }
    }

    return 0;
}
