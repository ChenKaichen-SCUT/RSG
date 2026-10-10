#include <assert.h>
#include <stdio.h>

int main() {
    int a;
    int b;
    int am;
    int bm;
    am = a;
    bm = b;
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    
  assert (((am <= bm) && (a > 0)) || ((a > 0) && (b > 0)) || ((am <= bm) && (am - bm > -1)) || ((b > 0) && (am - bm > -1))); // CondTerm
    while (am != bm) {
        printf("am:%d,bm:%d,a:%d,b:%d\n", am, bm, a, b);
        if (am > bm) {
            bm = bm+b;
        } else {
            am = am+a;
        }
    }

    return 0;
}
