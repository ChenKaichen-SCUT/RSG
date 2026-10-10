###include <stdio.h>
## 111
##int main()
##{
##    int x, y, z;
##    scanf("%d%d%d", &x, &y, &z);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    
##    if (x > z || y > z)
##        return 0;
##    while (x != y)
##    {
##        printf("x:%d,y:%d,z:%d\n", x, y, z);
##
##        x++;
##        y++;
##        if (x > z)
##            x = z;
##        if (y > z)
##            y = y - 1;
##    }
##}
##
##
!vars
x y z

!pvars
x' y' z'

!path
#x<=z
#y<=z
x>=y+1
x>=z+1
x'=z
y>=z+1
y'=y
z'=z

!path
#x<=z
#y<=z
x>=y+1
x>=z+1
x'=z
y<=z
y'=y+1
z'=z

!path
#x<=z
#y<=z
x>=y+1
x<=z
x'=x+1
y>=z+1
y'=y
z'=z

!path
#x<=z
#y<=z
x>=y+1
x<=z
x'=x+1
y<=z
y'=y+1
z'=z



!path
#x<=z
#y<=z
x<=y-1
x>=z+1
x'=z
y>=z+1
y'=y
z'=z

!path
#x<=z
#y<=z
x<=y-1
x>=z+1
x'=z
y<=z
y'=y+1
z'=z

!path
#x<=z
#y<=z
x<=y-1
x<=z
x'=x+1
y>=z+1
y'=y
z'=z

!path
#x<=z
#y<=z
x<=y-1
x<=z
x'=x+1
y<=z
y'=y+1
z'=z
