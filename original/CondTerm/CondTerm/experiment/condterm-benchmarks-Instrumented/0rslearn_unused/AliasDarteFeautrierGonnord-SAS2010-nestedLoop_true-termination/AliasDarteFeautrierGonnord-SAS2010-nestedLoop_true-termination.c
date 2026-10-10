/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

#include <stdio.h>

int main() {
    int t, j, k, m, n, N;
	scanf("%d%d%d%d%d%d", &t, &j, &k, &n, &m, &N);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

	if (0 <= n && 0 <= m && 0 <= N) {
		t = 0;
		while (t < n) {
			printf("t:%d,j:%d,k:%d,n:%d,m:%d,N:%d\n", t, j, k, n, m, N);
			j = 0;
			while (j < m) {
				j = j + 1;
				k = t;
				while (k < N) {
					k = k + 1;
                }
				t = k;
			}
			t = t + 1;
		}
	}
	return 0;
}
