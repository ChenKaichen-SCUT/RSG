#include <assert.h>
#include <stdio.h>

int main() {
    int _i;
    int j;
    int t;
    scanf("%d%d", &_i, &j);
    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
    t = 0;
    
  assert (((_i <= 0) || (j <= 0)) && ((_i <= 0) || (j > -1)) && ((j <= 0) || (_i > -1)) && ((_i > -1) || (j > -1))); // CondTerm
    while (_i != 0 && j != 0) {
        printf("_i:%d,j:%d\n", _i, j);
        t = _i;
        _i = j;
        j = t;
    }
    
    return 0;
}
