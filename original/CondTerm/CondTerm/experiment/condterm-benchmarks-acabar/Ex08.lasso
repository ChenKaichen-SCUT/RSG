###include <stdio.h>
## 111
##int main() {
##    int t;
##    int up;
##    scanf("%d", &t);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    up = 0;
##    
##    while (t > 0) {
##        printf("t:%d\n", t);
##        if (t == 1) {
##            up = 1;
##        }
##        if (t == 10) {
##            up = 0;
##        }
##        if (up == 1) {
##            t = t+1;
##        } else {
##            t = t-1;
##        }
##    }
##    
##    return 0;
##}
##
##
!vars
t up

!pvars
t' up'

!path
#up=0
t>=1
t=1
up'=1
t'=t+1

!path
#up=0
t>=1
t=10
up'=0
t'=t-1

!path
#up=0
t>=1
t>=2
t>=11
up=1
t'=t+1
up'=up

!path
#up=0
t>=1
t>=2
t>=11
up<=0
t'=t-1
up'=up

!path
#up=0
t>=1
t>=2
t<=9
up=1
t'=t+1
up'=up

!path
#up=0
t>=1
t>=2
t<=9
up<=0
t'=t-1
up'=up
