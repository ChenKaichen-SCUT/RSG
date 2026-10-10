###include<stdio.h>
## 111
##int main() {
##  int x = 5;
##  int y = 1;
##  int z = 17;
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##  
##  while (!(x == y && y == z)) {
##    printf("x:%d,y:%d,z:%d\n", x, y, z);
##    x = x + 1;
##    y = y * 2;
##    z = z - 3;
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
#x=5
#y=1
#z=17
x>=y+1
x'=x+1
y'=y*2
z'=z-3

!path
#x=5
#y=1
#z=17
x<=y-1
x'=x+1
y'=y*2
z'=z-3

!path
#x=5
#y=1
#z=17
y>=z+1
x'=x+1
y'=y*2
z'=z-3

!path
#x=5
#y=1
#z=17
y<=z-1
x'=x+1
y'=y*2
z'=z-3
