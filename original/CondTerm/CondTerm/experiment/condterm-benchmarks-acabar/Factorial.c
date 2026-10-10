var*var


###include <stdio.h>
##
##int main() {
##    int j;
##    int t;
##    int fac;
##    scanf("%d", &j);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    t = 1;
##    fac = 1;
##    
##    while (fac != j) {
##        printf("j:%d,fac:%d,t:%d\n", j, fac, t);
##        fac = fac * t;
##        t = t+1;
##    }
##	
##    return 0;
##}
##
##
!vars
j fac t

!pvars
j' fac' t'

!path
t=1
fac=1
fac>=j+1
fac'=fac*t
t'=t+1

!path
t=1
fac=1
fac<=j-1
fac'=fac*t
t'=t+1
