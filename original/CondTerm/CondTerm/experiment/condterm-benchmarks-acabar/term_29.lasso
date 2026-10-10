###include <stdio.h>
###include <stdlib.h>
## 111
##int _nondet_5() {
##  return rand()%5;
##}
##int _nondet_4() {
##  return rand()%4;
##}
##int _nondet_3() {
##  return rand()%3;
##}
##int _nondet_2() {
##  return rand()%2;
##}
##
##int main() {
##  int x = 0;
##  int y = 0;
##  int z = 1;
##  int N;
##  scanf("%d", &N);
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##  while (x < N)
##  {
##    printf("x:%d,y:%d,z:%d,N:%d\n", x, y, z, N);
##    if      (_nondet_5() == 0 && z == 1) { y = 5; z = 0; }
##    else if (_nondet_4() == 0 && z == 0) { y = -3; z = 1; }
##    else if (_nondet_3() == 0 && z == 1) { y = 7; z = 0; }
##    else if (_nondet_2() == 0 && z == 0) { y = -2; z = 1; }
##    else y = 1;
##
##    x = x + y;
##  }
##}
##
##
!vars
x y z N

!pvars
x' y' z' N'

!path
#x=0
#y=0
#z=1
x<=N-1
z=1
y'=5
z'=0
x'=x+5
N'=N

!path
#x=0
#y=0
#z=1
x<=N-1
z=1
y'=7
z'=0
x'=x+7
N'=N

!path
#x=0
#y=0
#z=1
x<=N-1
z=0
y'=-3
z'=1
x'=x-3
N'=N

!path
#x=0
#y=0
#z=1
x<=N-1
z=0
y'=-2
z'=1
x'=x-2
N'=N

!path
#x=0
#y=0
#z=1
x<=N-1
y'=1
z'=z
N'=N
x'=x+1

