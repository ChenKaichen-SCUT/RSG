###include <stdio.h>
## 111
##int main() {
##    int t;
##    int j;
##    j = 100;
##    t = 0;
##    
##    while (t < j) {
##        j = j+1;
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
#j=100
#t=0
t<=j-1
j'=j+1
t'=t+1
