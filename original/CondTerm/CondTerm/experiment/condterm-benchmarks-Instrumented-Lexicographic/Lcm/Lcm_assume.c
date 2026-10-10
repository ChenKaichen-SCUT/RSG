#include <assert.h>
#include <stdio.h>

int main() {
    int a;
    int b;
    int am;
    int bm;
    am = a;
    bm = b;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
  assert (((am <= bm) && (a > 0)) || ((a > 0) && (b > 0)) || ((am <= bm) && (am - bm > -1)) || ((b > 0) && (am - bm > -1))); // CondTerm
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
