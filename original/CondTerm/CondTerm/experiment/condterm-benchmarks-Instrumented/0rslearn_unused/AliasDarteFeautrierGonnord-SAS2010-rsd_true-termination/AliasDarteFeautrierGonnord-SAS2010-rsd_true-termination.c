/*
 * Program used in the experimental evaluation of the following paper.
 * 2010SAS - Alias,Darte,Feautrier,Gonnord, Multi-dimensional Rankings, Program Termination, and Complexity Bounds of Flowchart Programs
 *
 * Date: 2014
 * Author: Caterina Urban
 */

#include <stdio.h>
#include <stdlib.h>

int main() {
    int r, da, db, temp;
	scanf("%d", &r);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
	if (r >= 0) {
		da = 2 * r;
		db = 2 * r;
		while (da >= r) {
			printf("da:%d,r:%d,db:%d,temp:%d\n", da, r, db, temp);
			if (rand() != 0) {
				da = da - 1;
			} else {
				temp = da;
				da = db - 1;
				db = da;
			}
		}
	}
	return 0;
}
