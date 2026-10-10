###include<stdio.h>
## 111
##int main() {
##  int x = 4;
##  int y = -5;
##  int z = 1;
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##  
##  while (x + y != z) {
##    printf("x:%d,y:%d,z:%d\n", x, y, z);
##    x = x * -3;
##    y = y + 2;
##    z = z - 36;
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
#x=4
#y=-5
#z=1
x+y>=z+1
x'=-3*x
y'=y+2
z'=z-36

!path
#x=4
#y=-5
#z=1
x+y<=z-1
x'=-3*x
y'=y+2
z'=z-36
