#include <stdio.h>

int main() {
    int t;
    int j;
    scanf("%d%d", &t, &j);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (1) {
        printf("t:%d,j:%d\n", t, j);
        if (t < j) {
            t = t+4;
        } else {
            j = j+1;
            t = t+2;
        }
    }
	
    return 0;
}
