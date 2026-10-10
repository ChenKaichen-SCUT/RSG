##/*
## * Date: 2013-05-02
## * Author: heizmann@informatik.uni-freiburg.de
## *
## */
###include <stdio.h>
##  111 w1
##int main()
##{
##    int x;
##	x = 7;
##	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##	while (1) {
##		printf("x:%d\n", x);
##		x = 2;
##	}
##	return 0;
##}
##
##
!vars
x

!pvars
x'

!path
#x=7
x'=2
