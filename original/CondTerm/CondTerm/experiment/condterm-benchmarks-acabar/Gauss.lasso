###include <stdio.h>
## 111
##int main() {
##    int n;
##    int sum;
##    scanf("%d", &n);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    sum = 0;
##    
##    while (n != 0) {
##        printf("n:%d\n", n);
##        sum = sum + n;
##        n = n - 1;
##    }
##
##    return 0;
##}
##
##
!vars
n sum

!pvars
n' sum'

!path
#sum=0
n>=1
sum'=sum+n
n'=n-1

!path
#sum=0
n<=-1
sum'=sum+n
n'=n-1
