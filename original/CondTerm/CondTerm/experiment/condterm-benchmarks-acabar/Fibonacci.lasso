###include <stdio.h>
## 111
##int main() {
##    int n;
##    int _i;
##    int j;
##    int t;
##    scanf("%d", &n);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    _i = 0;
##    j = 1;
##    t = 0;
##    
##    while (j != n) {
##        printf("j:%d,n:%d,_i:%d,t:%d\n", j, n, _i, t);
##        t = j+_i;
##        _i = j;
##        j = t;
##    }
##	
##    return 0;
##}
##
##
!vars
i j n t

!pvars
i' j' n' t'

!path
#i=0
#j=1
#t=0
j>=n+1
t'=j+i
i'=j
j'=t
n'=n

!path
#i=0
#j=1
#t=0
j<=n-1
t'=j+i
i'=j
j'=t
n'=n
