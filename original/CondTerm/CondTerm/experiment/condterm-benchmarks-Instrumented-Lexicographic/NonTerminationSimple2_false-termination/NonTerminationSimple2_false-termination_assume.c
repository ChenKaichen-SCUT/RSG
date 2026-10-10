#include <assert.h>
/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Simple example for non-termination
 */

#include <stdio.h>

int main()
{
	int x;
    scanf("%d", &x);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");

  assert (x <= -1); // CondTerm
	while (x >= 0) {
		printf("%d\n", x);
		x = x + 1;
	}
    return 0;
}
