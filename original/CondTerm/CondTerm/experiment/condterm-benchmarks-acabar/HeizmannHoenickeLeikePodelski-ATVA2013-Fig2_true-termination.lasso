###include <stdio.h>
## 111
##int main()
##{
##    int y;
##    scanf("%d", &y);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    int x = y + 42;
##    while (x >= 0)
##    {
##        printf("y:%d,x:%d\n", y, x);
##        y = 2 * y - x;
##        x = (y + x) / 2;
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
#x=y+42
x>=0
y'=2*y-x
2*x'=y'+x
