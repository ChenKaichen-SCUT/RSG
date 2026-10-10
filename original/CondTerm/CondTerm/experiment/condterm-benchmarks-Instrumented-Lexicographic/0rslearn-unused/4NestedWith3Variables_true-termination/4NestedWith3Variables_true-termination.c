/*
 * Date: 2014-06-08
 * Author: leike@informatik.uni-freiburg.de
 *
 * (a, b) is a vector that is rotated around (0, 0) and scaled by a factor of 5.
 * I.e., (a, b) is on an outward spiral around (0, 0).
 *
 * This program terminates because on average, (a, b) is (0, 0),
 * hence q decreases by 1 on average.
 */
 #include <stdio.h>

int main()
{
	int a, b, q, olda;
	scanf("%d%d%d", &q, &a, &b);
	printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	
	while (q > 0) {
		printf("q:%d,a:%d,b:%d,olda:%d\n", q, a, b, olda);
	
		q = q + a - 1;
		olda = a;
		a = 3*olda - 4*b;
		b = 4*olda + 3*b;
	}
	return 0;
}
