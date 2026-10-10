###include <stdio.h>
##
##int main() {
##    int t;
##    t = 0;
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    
##    while (t < 100) {
##        printf("t:%d\n", t);
##        t = t+1;
##        t = t-1;
##    }
##    
##    return 0;
##}
## 111
##
!vars
t

!pvars
t'

!path
#t=0
t<=99
t'=t
