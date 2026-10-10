#include <assert.h>
/*
 * Date: 2013-12-16
 * Author: leike@informatik.uni-freiburg.de
 *
 * Does not terminate for c >= 0.
 */

#include <stdio.h>

int main()
{
	int c, x;
    scanf("%d%d", &x, &c);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
  assert ((c <= -1) || (x <= -1)); // CondTerm
	while (x >= 0) {
		printf("%d,%d\n", x, c);
		x = x + c;
	}
    return 0;
}
