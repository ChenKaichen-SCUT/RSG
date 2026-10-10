/*
 * Date: 2014-06-26
 * Author: leike@informatik.uni-freiburg.de
 */

#include <stdio.h>
#include <stdlib.h>

int main()
{
	int x, t;
    scanf("%d", &x);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
	while (x >= 0) {
		printf("%d\n", x);
		t = rand();
		if (t != 0) {
			printf("L1\n");
			x = x + 1;
		} else {
			printf("L2\n");
			t = rand();
			if (t != 0) {
				printf("L3\n");
			x = x + 2;
		} else {
			printf("L4\n");
			t = rand();
			if (t != 0) {
				printf("L5\n");
			x = x + 3;
		} else {
			printf("L6\n");
			t = rand();
			if (t != 0) {
				printf("L7\n");
			x = x + 4;
		} else {
			printf("L8\n");
			x = -1;
		}}}}
	}
	return 0;
}
