#include <stdio.h>

int main() {
    int a;
    int b;
    int am;
    int bm;
    am = a;
    bm = b;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (am != bm) {
        printf("#\n");
        if (am > bm) {
            printf("L1\n");
            bm = bm+b;
        } else {
            printf("L2\n");
            am = am+a;
        }
    }

    return 0;
}
