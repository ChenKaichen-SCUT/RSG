#include <assert.h>
/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

#include <stdio.h>

int main()
{
    int c, x;
	scanf("%d%d", &x, &c);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (c == 0) {
  assert (x <= -1); // CondTerm
	    while (x >= 0) {
			printf("x:%d,c:%d\n", x, c);
		    x = x + c;
	    }
    }
	return 0;
}
