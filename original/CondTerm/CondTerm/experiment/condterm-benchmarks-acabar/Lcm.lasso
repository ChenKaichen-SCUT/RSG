###include <stdio.h>
## 111
##int main() {
##    int a;
##    int b;
##    int am;
##    int bm;
##    am = a;
##    bm = b;
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    
##    while (am != bm) {
##        printf("am:%d,bm:%d,a:%d,b:%d\n", am, bm, a, b);
##        if (am > bm) {
##            bm = bm+b;
##        } else {
##            am = am+a;
##        }
##    }
##
##    return 0;
##}
##
##
!vars
a b am bm

!pvars
a' b' am' bm'

!path
#am=a
#bm=b
am>=bm+1
bm'=bm+b
a'=a
b'=b
am'=am

!path
#am=a
#bm=b
am<=bm-1
am'=am+a
bm'=bm
a'=a
b'=b
