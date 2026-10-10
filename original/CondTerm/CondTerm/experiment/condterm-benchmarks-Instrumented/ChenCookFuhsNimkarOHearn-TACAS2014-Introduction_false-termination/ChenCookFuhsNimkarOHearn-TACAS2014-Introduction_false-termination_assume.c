#include <assert.h>
/*
 * Program from the example depicted in the introduction of
 * 2014TACAS - Chen,Cook,Fuhs,Nimkar,O’Hearn - Proving Nontermination via Safety
 *
 * Date: 2014-06-28
 * Author: Matthias Heizmann
 *
 */
#include <stdio.h>
#include <stdlib.h>

int main() {
    int k, n;
	scanf("%d%d", &k, &n);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (k >= 0) {
		// skip
	} else {
		n = -1;
	}
  assert (n <= -1); // CondTerm
	while (n >= 0) {
		printf("k:%d,n:%d\n", k, n);
		n = rand();
	}
	n = 2;
	return 0;
}
