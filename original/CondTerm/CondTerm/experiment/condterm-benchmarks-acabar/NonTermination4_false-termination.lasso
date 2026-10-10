##/*
## * Date: 2013-12-20
## * Author: leike@informatik.uni-freiburg.de
## *
## * Difficult example for non-termination
## *
## * y = x^log_2(3)
## */
###include <stdio.h>
##  111
##int main()
##{
##    int x, y;
##	x = 1;
##	y = 1;
##	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##	while (x >= 0) {
##		printf("x:%d,y:%d\n", x, y);
##		x = 2*x;
##		y = 3*y;
##	}
##	return 0;
##}
##
##
!vars
x y

!pvars
x' y'

!path
#x=1
#y=1
x>=0
x'=2*x
y'=3*y
