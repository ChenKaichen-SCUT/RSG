###include <stdio.h>
## 111
##int main()
##{
##    int x;
##    scanf("%d", &x);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    int y = 3;
##    while (x >= 0)
##    {
##        printf("x:%d,y:%d\n", x, y);
##        x = x - y;
##        y = (y + 2) / 3;
##    }
##    return 0;
##}
##
##
!vars
x y

!pvars
x' y'

!path
#y=3
x>=0
x'=x-y
3*y'=y+2
