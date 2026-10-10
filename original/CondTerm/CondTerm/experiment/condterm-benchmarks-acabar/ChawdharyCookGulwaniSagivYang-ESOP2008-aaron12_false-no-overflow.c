var*var


##while (x >= y) {
##	if (_nondet_2() != 0) {
##		x = x + 1;
##		y = y + x;
##	} else {
##		x = x - z;
##		y = y + (z * z);
##		z = z - 1;
##	}
##}
##
##
!vars
x y z

!pvars
x' y' z'

!path
x>=y
x'=x+1
y'=y+x
z'=z

!path
x>=y
x'=x-z
y'=z*z+y
z'=z-1
