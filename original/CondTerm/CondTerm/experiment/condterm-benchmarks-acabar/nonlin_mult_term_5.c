var*var

###include <stdio.h>
##
##int main() {
##  int x, y;
##  scanf("%d%d", &x, &y);
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##  if (x <= 0) return 0;
##  if (y <= 0) return 0;
##  x = x*y;
##
##  while (x != 0)
##  {
##    printf("x:%d,y:%d\n", x, y);
##    x = x - y;
##  }
##}
##
##
!vars
x y

!pvars
x' y'

!path
#x>=1
y>=1
x>=1
x'=x-y
y'=y

!path
x>=1
y>=1
x<=-1
x'=x-y
y'=y
