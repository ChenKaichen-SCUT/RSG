##if (x <= 0 || y <= 0) return 0;
##
##while (x + y > 0) {
##    x = -4*x + 18;
##    y = -6*y + 13;
##}
## 111
##
!vars
x y

!pvars
x' y'

!path
#x>=1
#y>=1
x+y>=1
x'=-4*x+18
y'=-6*y+13
