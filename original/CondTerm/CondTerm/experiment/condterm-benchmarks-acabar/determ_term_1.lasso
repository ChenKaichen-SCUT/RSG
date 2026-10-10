###include<stdio.h>
##
##int main() {
##  int x = -10;
##  int y = 1;
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##  
##  while (x != 0) {
##    printf("x:%d,y:%d\n", x, y);
##    x = x + y;
##    y = y + 1;
##  }
##  return 0;
##}
## 111
##
!vars
x y

!pvars
x' y'

!path
#x=-10
#y=1
x>=1
x'=x+y
y'=y+1

!path
#x=-10
#y=1
x<=-1
x'=x+y
y'=y+1

