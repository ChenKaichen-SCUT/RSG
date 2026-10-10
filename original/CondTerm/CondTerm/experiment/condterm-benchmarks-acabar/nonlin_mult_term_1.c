var*var

###include <stdio.h>
##
##int main()
##{
##    int x, y;
##    x = 1;
##    scanf("%d", &y);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    if (y <= 1)
##        return 0;
##
##    while (x < 10000)
##    {
##        printf("x:%d,y:%d\n", x, y);
##        x = x * y;
##    }
##}
##
##
!vars
x y

!pvars
x' y'

!path
x=1
y>=2
x<=9999
x'=x*y
y'=y
