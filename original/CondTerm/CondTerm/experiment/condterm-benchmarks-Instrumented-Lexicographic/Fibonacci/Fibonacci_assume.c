#include <assert.h>
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
    
  assert (((_i <= -1) || ((j <= 0) && (j <= n)) || ((j <= n) && (n > -1))) && ((n <= 3) || (j > 1) || (n > 4) || (_i + j > 1) || (j - t <= -1) || (j - t > 3)) && ((_i <= 0) || (j <= 0) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 1) || (_i + t <= 1) || (_i + j > 2) || (j - t <= -1) || (j - t > 3)) && ((n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 4) || (_i + t <= 1) || (_i - j >= 4) || (j - t <= -1) || (j - n > -1) || (j - t > 3)) && ((_i <= -1) || (j <= n) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 2) || (_i + t <= 1) || (_i - j >= 4) || (j - n <= -1) || (j - t <= -1) || (j - t > 3)) && ((_i >= j) || (n <= 3) || (j > t) || (n > 4) || (_i <= -t) || (_i + j <= 2) || (_i + t <= 1) || (_i + j > 3) || (_i - j >= 4) || (j - t <= -1) || (j - n > -1) || (j - t > 3))); // CondTerm
    while (j != n) {
        printf("%d\n", n);
        t = j+_i;
        _i = j;
        j = t;
    }
	
    return 0;
}
