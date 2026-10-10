###include <stdio.h>
##  111
##int main() {
##    int t;
##    int up;
##    scanf("%d", &t);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    up = 0;
##    
##    while (0 <= t && t <= 10) {
##        printf("t:%d,up:%d\n", t, up);
##        if (t >= 10) {
##            up = 0;
##        }
##        if (t <= 0) {
##            up = 1;
##        }
##        if (up >= 1) {
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
##
!vars
t up

!pvars
t' up'

!path
#up=0
0<=t
t<=10
t=10
up'=0
t'=t-1

!path
#up=0
0<=t
t<=10
t=0
up'=1
t'=t+1


!path
#up=0
0<=t
t<=10
t>=1
t<=9
up>=1
t'=t+1
up'=up

!path
#up=0
0<=t
t<=10
t>=1
t<=9
up<=0
t'=t-1
up'=up

