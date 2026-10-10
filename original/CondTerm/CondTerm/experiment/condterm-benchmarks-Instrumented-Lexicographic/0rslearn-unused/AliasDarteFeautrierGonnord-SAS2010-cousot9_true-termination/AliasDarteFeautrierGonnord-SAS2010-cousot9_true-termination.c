/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */
 #include <stdio.h>

int main() {
    int i, j, N;
    scanf("%d%d", &j, &N);
	i = N;
	while (i > 0) {
		printf("i:%d,j:%d,N:%d\n", i, j, N);
		if (j > 0) {
			j = j - 1;
		} else {
			j = N;
			i = i - 1;
		}
	}
	return 0;
}
