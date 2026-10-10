###include <stdio.h>
## 111
##int main() {
##    int a;
##    int b;
##    a = 1;
##    b = 2;
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    
##    while (a + b < 5) {
##        printf("a:%d,b:%d\n", a, b);
##        a = a - b;
##        b = a + b;
##        a = b - a;
##    }
##    
##    return 0;
##}
##
##
!vars
a b

!pvars
a' b'

!path
#a=1
#b=2
a+b<=4
b'=a
a'=0
