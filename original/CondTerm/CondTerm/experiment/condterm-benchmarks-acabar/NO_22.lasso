###include <stdio.h>
## 111
##int main() {
##    int t;
##    t = 0;
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    
##    while (t < 100) {
##        printf("t:%d\n", t);
##        if (t < 50) { t = t+1; }
##        else { t = t-1; }
##    }
##    
##    return 0;
##}
##
##
!vars
t

!pvars
t'

!path
#t=0
t<=99
t<=49
t'=t+1

!path
#t=0
t<=99
t>=50
t'=t-1
