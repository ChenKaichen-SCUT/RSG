var*var

###include <stdio.h>
##
##int main()
##{
##    int x, y, z;
##    scanf("%d%d%d", &x, &y, &z);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    if (x <= 0)
##        return 0;
##    if (y <= 1)
##        return 0;
##    if (z <= 1)
##        return 0;
##
##    while (x < 1000000)
##    {
##        printf("x:%d,y:%d,z:%d\n", x, y, z);
##        x = x * y * z;
##    }
##}
##
##
!vars
x y z

!pvars
x' y' z'

!path
x>=1
y>=2
z>=2
x<=999999
x'=x*y*z
y'=y
z'=z
