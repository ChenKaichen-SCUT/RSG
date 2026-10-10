###include <stdio.h>
## 111
##int main()
##{
##  int x = 0;
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##  while (x < 1000)
##  {
##    printf("x:%d\n", x);
##    if (x != 7777) x++;
##  }
##}
##
##
!vars
x

!pvars
x'

!path
#x=0
x<=999
x>=7778
x'=x+1

!path
#x=0
x<=999
x<=7776
x'=x+1
