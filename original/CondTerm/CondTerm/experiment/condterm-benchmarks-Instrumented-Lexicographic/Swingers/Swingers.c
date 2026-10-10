#include <stdio.h>

int main() {
    int bob;
    int samantha;
    int temp;
    bob = 13;
    samantha = 17;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
    while (bob + samantha < 100) {
        printf("#\n");
        temp = bob;
        bob = samantha;
        samantha = temp;
    }
    
    return 0;
}