###include <stdio.h>
## 111
##int main() {
##    int x;
##    int c;
##    scanf("%d", &x);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    c = 1;
##
##    while (c > 0) {
##        printf("x:%d,c:%d\n", x, c);
##        if (x > 100) {
##            x = x-10;
##            c = c-1;
##        } else {
##            x = x+11;
##            c = c+1;
##        }
##    }
##
##    return 0;
##}
##
##
!vars
x c

!pvars
x' c'

!path
#c=1
c>=1
x>=101
x'=x-10
c'=c-1

!path
#c=1
c>=1
x<=100
x'=x+11
c'=c+1
