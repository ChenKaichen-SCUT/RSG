#include <stdio.h>

int main() {
    int n;
    int _i;
    int j;
    int t;
    scanf("%d", &n);
    printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    _i = 0;
    j = 1;
    t = 0;
    
    while (j != n) {
        printf("%d\n", n);
        t = j+_i;
        _i = j;
        j = t;
    }
	
    return 0;
}
