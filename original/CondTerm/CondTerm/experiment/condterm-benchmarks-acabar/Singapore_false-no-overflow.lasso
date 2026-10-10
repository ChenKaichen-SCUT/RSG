###include <stdio.h>
## 111
##int main()
##{
##    int x;
##    int y;
##    scanf("%d%d", &x, &y);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    if (x + y <= 0)
##    {
##        while (x > 0)
##        {
##            printf("x:%d,y:%d\n", x, y);
##            x = x + x + y;
##            y = y - 1;
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
#x+y<=0
x>=1
x'=x+x+y
y'=y-1
