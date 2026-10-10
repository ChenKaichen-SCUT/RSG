###include <stdio.h>
## 111
##int main() {
##    int t;
##    int j;
##    j = 0;
##    t = 0;
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    
##    while (t <= j) {
##        printf("t:%d,j:%d\n", t, j);
##        if (j-t < 1) { j = j+2; }
##        t = t+1;
##    }
##    
##    return 0;
##}
##
##
!vars
t j

!pvars
t' j'

!path
#j=0
#t=0
t<=j
j-t<=0
j'=j+2
t'=t+1

!path
#j=0
#t=0
t<=j
j-t>=1
t'=t+1
j'=j

