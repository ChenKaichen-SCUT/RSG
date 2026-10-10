###include <stdio.h>
## 111
##int main()
##{
##    int x, y;
##    scanf("%d%d", &x, &y);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    if (x > y)
##    {
##        while (x >= 0)
##        {
##            printf("x:%d,y:%d\n", x, y);
##            y = 2 * y - x;
##            x = (y + x + 1) / 2;
##        }
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
#x>=y+1
x>=0
y'=2*y-x
2*x'=2*y+1

