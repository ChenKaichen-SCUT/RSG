###include <stdio.h>
## 111
##int main()
##{
##    int x, y;
##    scanf("%d%d", &x, &y);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    int c1 = 0;
##    int c2 = 0;
##
##    while (x > y)
##    {
##        printf("x:%d,y:%d,c1:%d,c2:%d\n", x, y, c1, c2);
##        x = x + c1 / 3;
##        y = y + c2 / 2;
##        c1 = c1 + 2;
##        c2 = c2 + 3;
##    }
##}
##
##
!vars
x y c1 c2

!pvars
x' y' c1' c2'

!path
#c1=0
#c2=0
x>=y+1
3*x'=3*x+c1
2*y'=2*y+c2
c1'=c1+2
c2'=c2+3
