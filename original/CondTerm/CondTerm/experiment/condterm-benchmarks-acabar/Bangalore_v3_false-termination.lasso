##if (y <= x) {
##	while (x >= 0) {
##		x = x - y;
##	}
##}
## 111
##
!vars
x y

!pvars
x' y'

!path
#y<=x
x>=0
x'=x-y
y'=y

