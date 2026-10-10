/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */
 #include <stdio.h>


int main() {
    int a, b;
    scanf("%d%d", &a, &b);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");

	while (a < 30) {
		printf("a:%d,b:%d\n", a, b);
		while (b < a) {
			if (b > 5) {
				b = b + 7;
			} else {
				b = b + 2;
            }
			if (b >= 10 && b <= 12) {
				a = a + 10;
			} else {
				a = a + 1;
            }
		}
		a = a + 2;
		b = b - 10;
	}
	return 0;
}
