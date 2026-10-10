###include <stdio.h>
## 111
##int main() {
##    int t;
##    int range;
##    int up;
##    scanf("%d", &t);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    range = 20;
##    up = 0;
##    
##    while (0 <= t && t <= range) {
##        printf("t:%d,range:%d,up:%d\n", t, range, up);
##        if (t == 0) {
##            up = 1;
##        }
##        if (t == range) {
##            up = 0;
##        }
##        if (up == 1) {
##            t = t+1;
##        }
##        if (up == 0) {
##            t = t-1;
##        }
##        if (t == range-2) {
##            range = range-1;
##        }
##    }
##    
##    return 0;
##}
##
##
!vars
range up t

!pvars
range' up' t'

!path
#range=20
#up=0
0<=t
t<=range
t=0
t<=range-1
up'=1
t'=t+1
t=range-2
range'=range-1

!path
#range=20
#up=0
0<=t
t<=range
t=0
t<=range-1
up'=1
t'=t+1
t<=range-3
range'=range

!path
#range=20
#up=0
0<=t
t<=range
t=0
t<=range-1
up'=1
t'=t+1
t>=range-1
range'=range


!path
#range=20
#up=0
0<=t
t<=range
t=range
t>=1
up'=0
t'=t-1
t=range-2
range'=range-1

!path
#range=20
#up=0
0<=t
t<=range
t=range
t>=1
up'=0
t'=t-1
t>=range-1
range'=range

!path
#range=20
#up=0
0<=t
t<=range
t=range
t>=1
up'=0
t'=t-1
t<=range-3
range'=range
