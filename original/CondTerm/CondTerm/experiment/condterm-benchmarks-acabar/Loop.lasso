###include <stdio.h>
## 111
##int main() {
##    int a;
##    int b;
##    int t;
##    a = 5;
##    b = 3;
##    t = 0;
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    
##    while (t < 10) { 
##        printf("t:%d\n", t);
##        t = t + 0; 
##    }
##    
##    return 0;
##}
##
##
!vars
a b t

!pvars
a' b' t'

!path
#a=5
#b=3
#t=0
t<=9
t'=t+0
a'=a
b'=b
