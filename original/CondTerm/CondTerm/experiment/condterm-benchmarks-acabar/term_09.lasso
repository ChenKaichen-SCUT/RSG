###include <stdio.h>
## 111
##int main() {
##  int K, x, y;
##  scanf("%d%d%d", &K, &x, &y);
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##  if (!(x < y)) return 0;
##
##  while (y != K) {
##    printf("K:%d,x:%d,y:%d\n", K, x, y);
##    if (x == y) {
##      if (x > K) {
##        x = x - 1;
##      } else {
##        x = x + 1;
##      }
##      y = x;
##    } else {
##      y = y - 1;
##    }
##  }
##  return 0;
##}
##
##
!vars
x y K

!pvars
x' y' K'

!path
#x<=y-1
y>=K+1
x=y
x>=K+1
x'=x-1
y'=x
K'=K

!path
#x<=y-1
y>=K+1
x=y
x<=K
x'=x+1
y'=x
K'=K

!path
#x<=y-1
y>=K+1
x>=y+1
y'=y-1
x'=x
K'=K

!path
#x<=y-1
y<=K-1
x<=y-1
y'=y-1
x'=x
K'=K


!path
#x<=y-1
y<=K-1
x=y
x>=K+1
x'=x-1
y'=x
K'=K

!path
#x<=y-1
y<=K-1
x=y
x<=K
x'=x+1
y'=x
K'=K

!path
#x<=y-1
y<=K-1
x>=y+1
y'=y-1
x'=x
K'=K

!path
#x<=y-1
y<=K-1
x<=y-1
y'=y-1
x'=x
K'=K
