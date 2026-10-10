#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d", &t);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (t < 10) {
        j = t;
        while (j > 5) {
            printf("j:%d\n", j);
            j = j+1;
        }
        t = t+1;
    }
    
    return 0;
}
