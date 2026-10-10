###include <stdio.h>
## 111
##int main()
##{
##    int a, b, x, y;
##    scanf("%d%d%d%d", &a, &b, &x, &y);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    if (a == b + 1 && x < 0)
##    {
##        while (x >= 0 || y >= 0)
##        {
##            printf("a:%d,b:%d,x:%d,y:%d\n", a, b, x, y);
##
##            x = x + a - b - 1;
##            y = y + b - a - 1;
##        }
##    }
##    return 0;
##}
##
##
!vars
a b x y

!pvars
a' b' x' y'

!path
a=b+1
#x<=-1
x>=0
x'=x+a-b-1
y'=y+b-a-1

!path
a=b+1
#x<=-1
y>=0
x'=x+a-b-1
y'=y+b-a-1
