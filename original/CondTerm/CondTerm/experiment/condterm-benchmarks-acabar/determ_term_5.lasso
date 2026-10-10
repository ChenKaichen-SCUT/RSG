###include <stdio.h>
## 111
##int main()
##{
##  int _i, j, k;
##  _i = -7;
##  j = 2;
##  k = 8;
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##  while (_i != j)
##  {
##    printf("_i:%d,j:%d,k:%d\n", _i, j, k);
##    _i = _i + j - k;
##    j = j * 2;
##    k = k - 1;
##  }
##  return 0;
##}
##
!vars
i j k

!pvars
i' j' k'

!path
#i=-7
#j=2
#k=8
i>=j+1
i'=i+j-k
j'=2*j
k'=k-1

!path
#i=-7
#j=2
#k=8
i<=j-1
i'=i+j-k
j'=2*j
k'=k-1
