###include <stdio.h>
## 111
##int main() {
##    int t;
##    t = 3;
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    while (t >= 3) {
##        printf("t:%d\n", t);
##        if (t > 5) {
##            t = t+3;
##        } else {
##            if (t > 10) {
##                t = t-2;
##            } else {
##                t = t+1;
##            }
##        }
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
#t=3
t>=3
t>=6
t'=t+3

!path
#t=3
t>=3
t<=5
t>=11
t'=t-2

!path
#t=3
t>=3
t<=5
t<=10
t'=t+1

