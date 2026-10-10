#include <stdio.h>

int main() {
    int t;
    int b;
    scanf("%d", &t);
  printf("[Testing] <Interface V3.0TR> (Basic lexical method)\n");
    
    while (t != 1 && t != 0) {
        printf("%d\n", t);
        t = t-2;
    }
    
    return 0;
}
