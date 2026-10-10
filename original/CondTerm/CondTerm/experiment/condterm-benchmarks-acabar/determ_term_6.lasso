###include <stdio.h>
## 111
##int main()
##{
##  int x = 8;
##  int y = 9;
##  int z = -2;
##  int oldx;
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##  while (x + y + z != 0)
##  {
##    printf("x:%d,y:%d,z:%d,oldx:%d\n", x, y, z, oldx);
##    oldx = x;
##    x = -y + 1;
##    y = 2 * oldx + z;
##    z = z * 3;
##  }
##  return 0;
##}
##
##
!vars
x y z

!pvars
x' y' z'

!path
#x=8
#y=9
#z=-2
x+y+z>=1
x'=-y+1
y'=2*x+z
z'=3*z

!path
#x=8
#y=9
#z=-2
x+y+z<=-1
x'=-y+1
y'=2*x+z
z'=3*z
