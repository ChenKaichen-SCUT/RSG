#include <stdio.h>

int main() {
    int j;
    int t;
    int fac;
    scanf("%d", &j);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    t = 1;
    fac = 1;
    
    while (fac != j) {
        printf("%d\n", j);
        fac = fac * t;
        t = t+1;
    }
	
    return 0;
}
