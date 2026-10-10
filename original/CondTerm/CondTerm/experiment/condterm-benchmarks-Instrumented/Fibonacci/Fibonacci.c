#include <stdio.h>

int main() {
    int n;
    int _i;
    int j;
    int t;
    scanf("%d", &n);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    _i = 0;
    j = 1;
    t = 0;
    
    while (j != n) {
        printf("j:%d,n:%d,_i:%d,t:%d\n", j, n, _i, t);
        t = j+_i;
        _i = j;
        j = t;
    }
	
    return 0;
}
