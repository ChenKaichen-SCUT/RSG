###include <stdio.h>
## 111
##int main()
##{
##  int a, b, c, d, _e;
##  a = 0;
##  b = 0;
##  c = 0;
##  d = 0;
##  _e = 0;
##  printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##  while (a == 0)
##  {
##    printf("a:%d,b:%d,c:%d,d:%d,_e:%d\n", a, b, c, d, _e);
##    a = a + b;
##    b = b + c;
##    c = c + d;
##    d = d + _e;
##    _e = _e + 1;
##  }
##  return 0;
##}
##
##
!vars
a b c d e

!pvars
a' b' c' d' e'

!path
#a=0
#b=0
#c=0
#d=0
#e=0
a=0
a'=a+b
b'=b+c
c'=c+d
d'=d+e
e'=e+1
