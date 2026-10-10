###include <stdio.h>
## 111
##int main() {
##  int x, y;
##  scanf("%d%d", &x, &y);
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##  if (x < y) return 0;
##  while (x != y)
##  {
##    printf("x:%d,y:%d\n", x, y);
##    x--; y++;
##    if (x < y) x = x + 15;
##  }
##}
##
!vars
x y

!pvars
x' y'

!path
#x>=y
x>=y+1
x'=x-1
y'=y+1

!path
#x>=y
x<=y-1
x'=x+14
y'=y+1
