###include <stdio.h>
## 111
##int main() {
##    int t;
##    int range;
##    scanf("%d", &t);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    range = 20;
##    
##    while (-range <= t && t <= range) {
##        printf("t:%d,range:%d\n", t, range);
##        if (range-t < 5 || range+t < 5) {
##            t = t*(-1);
##        } else {
##            range = range+1;
##            t = t-1;
##            if (t == 0) {
##                range = -1;
##            }
##        }
##    }
##    
##    return 0;
##}
##
##
!vars
t range

!pvars
t' range'

!path
range=20
-range<=t
t<=range
range-t<=4
t'=-t
range'=range

!path
range=20
-range<=t
t<=range
range+t<=4
t'=-t
range'=range

!path
range=20
-range<=t
t<=range
range-t>=5
range+t>=5
t=1
t'=0
range'=-1

!path
range=20
-range<=t
t<=range
range-t>=5
range+t>=5
t>=2
t'=t-1
range'=range+1

!path
range=20
-range<=t
t<=range
range-t>=5
range+t>=5
t<=0
t'=t-1
range'=range+1
