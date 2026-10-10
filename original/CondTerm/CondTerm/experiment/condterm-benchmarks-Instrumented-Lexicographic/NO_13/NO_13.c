#include <stdio.h>

int main() {
    int t;
    int j;
    j = 100;
    t = 0;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t < j) {
        printf("#\n");
        if (51 < j) { 
            printf("L1\n");
            t = t+1; j = j-1; }
        else { 
            printf("L2\n");
            t = t-1; j = j+1; }
    }
    
    return 0;
}