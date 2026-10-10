###include <stdio.h>
## 111
##int main()
##{
##  int _i, j;
##  j = 1;
##  _i = 10000;
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##  while (_i - j >= 1)
##  {
##    printf("_i:%d,j:%d\n", _i, j);
##
##    j = j + 1;
##    _i = _i - 1;
##  }
##  return 0;
##}
##
##
!vars
i j

!pvars
i' j'

!path
#j=1
#i=10000
i-j>=1
j'=j+1
i'=i-1
