#include <stdio.h>

int main() {
    int t;
    int j;
    j = 0;
    t = 0;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t <= j) {
        printf("#\n");
        if (j-t < 1) { 
            printf("L1\n");
            j = j+2; }
        t = t+1;
    }
    
    return 0;
}
