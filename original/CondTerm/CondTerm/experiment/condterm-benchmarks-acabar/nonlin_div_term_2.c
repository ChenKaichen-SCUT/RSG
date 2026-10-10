var*var


###include <stdio.h>
##
##int main() {
##  int x, y;
##  scanf("%d%d", &x, &y);
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##  if (x < y) return 0;
##  if (y <= 1) return 0;
##
##  while (x > 0)
##  {
##    printf("x:%d,y:%d\n", x, y);
##    x = x / y;
##  }
##}
##
##
!vars
x y

!pvars
x' y'

!path
x>=y
y>=2
x>=1
x'*y=x
y'=y
