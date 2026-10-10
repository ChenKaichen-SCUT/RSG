#include <stdio.h>

int main() {
    int bob;
    int samantha;
    int temp;
    bob = 13;
    samantha = 17;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (bob + samantha < 100) {
        printf("bob:%d,samantha:%d\n", bob, samantha);
        temp = bob;
        bob = samantha;
        samantha = temp;
    }
    
    return 0;
}