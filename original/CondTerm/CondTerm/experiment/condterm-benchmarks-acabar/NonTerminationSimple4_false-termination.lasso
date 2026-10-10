##/*
## * Date: 2014-06-26
## * Author: leike@informatik.uni-freiburg.de
## *
## * Does not terminate for y >= 5.
## */
##
###include <stdio.h>
## 111
##int main()
##{
##    int x, y;
##	scanf("%d%d", &x, &y);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##	if (y >= 5) {
##	    while (x >= 0) {
##		    y = y - 1;
##    	}
##    }
##	return 0;
##}
##
##
!vars
x y

!pvars
x' y'

!path
#y>=5
x>=0
y'=y-1
x'=x
