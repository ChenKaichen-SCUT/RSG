#include <assert.h>
/*
 * Date: 2013-12-20
 * Author: leike@informatik.uni-freiburg.de
 *
 * Difficult example for non-termination
 *
 * y = x^log_2(3)
 */
#include <stdio.h>

int main()
{
    int x, y;
	x = 1;
	y = 1;
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
  assert (x <= -1); // CondTerm
	while (x >= 0) {
		printf("#\n");
		x = 2*x;
		y = 3*y;
	}
	return 0;
}
