###include <stdio.h>
## 111
##int main() {
##    int _i;
##    int j;
##    int t;
##    scanf("%d%d", &_i, &j);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    t = 0;
##    
##    while (_i != 0 && j != 0) {
##        printf("_i:%d,j:%d\n", _i, j);
##        t = _i;
##        _i = j;
##        j = t;
##    }
##    
##    return 0;
##}
##
##
!vars
i j t

!pvars
i' j' t'

!path
#t=0
i>=1
j>=1
t'=i
i'=j
j'=t

!path
#t=0
i>=1
j<=-1
t'=i
i'=j
j'=t

!path
#t=0
i<=-1
j>=1
t'=i
i'=j
j'=t

!path
#t=0
i<=-1
j<=-1
t'=i
i'=j
j'=t
