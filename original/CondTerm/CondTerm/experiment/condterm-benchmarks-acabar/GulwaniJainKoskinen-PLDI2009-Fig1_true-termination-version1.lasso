###include <stdio.h>
## 111
##int main() {
##    int id, maxId, tmp;
##    scanf("%d%d", &id, &maxId);
##    printf("[Testing] <Interface V4.0> (Log all variables for reuse)\n");
##
##    if(0 <= id && id < maxId) {
##        tmp = id+1;
##        while(tmp!=id) {
##            printf("id:%d,maxId:%d,tmp:%d\n", id, maxId, tmp);
##            if (tmp <= maxId) {
##                tmp = tmp + 1;
##            } else {
##                tmp = -1;
##            }
##        }
##    }
##
##    return 0;
##}
##
##
!vars
id maxId tmp

!pvars
id' maxId' tmp'

!path
0<=id
id<=maxId-1
#tmp=id+1
tmp>=id+1
tmp<=maxId
tmp'=tmp+1
id'=id
maxId'=maxId

!path
0<=id
id<=maxId-1
#tmp=id+1
tmp>=id+1
tmp>=maxId+1
tmp'=-1
id'=id
maxId'=maxId


!path
0<=id
id<=maxId-1
#tmp=id+1
tmp<=id-1
tmp<=maxId
tmp'=tmp+1
id'=id
maxId'=maxId

!path
0<=id
id<=maxId-1
#tmp=id+1
tmp<=id-1
tmp>=maxId+1
tmp'=-1
id'=id
maxId'=maxId
