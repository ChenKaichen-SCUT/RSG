###include <stdio.h>
## 111
##int main() {
##    int x;
##    int y;
##    int z;
##    int res;
##    scanf("%d%d", &x, &y);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##    z = y;
##    res = 0;
##    
##    while (z > 0 && (y == 0 || y > 0 && x > 0))	{
##        printf("x:%d,y:%d,z:%d\n", x, y, z);
##        
##        if (y == 0) {
##            res = res + 1;
##            y = z;
##        }
##        else {
##            x = x + 1;
##            y = y - 1;
##        }
##    }
##    
##    return 0;
##}
##
##
!vars
x y z res

!pvars
x' y' z' res'

!path
#z=y
#res=0
z>=1
y=0
res'=res+1
y'=z
x'=x
z'=z

!path
#z=y
#res=0
z>=1
y>=1
x>=1
x'=x+1
y'=y+1
z'=z
res'=res
