#include <stdio.h>
int main() {
 int p,x;
 if(scanf("%d%d", &p,&x)!=2) return 1;
 printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
 while ((p == 0 && 0 <= x && x <= 2) || (p == 1 && 3 <= x && x <= 4)) {
 printf("p:%d,x:%d\n",p,x);
 x=4-x;
 p=1-p;
 }
 return 0;
}
