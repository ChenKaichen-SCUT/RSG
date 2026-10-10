##if (n >= 0 && m > 0)
##{
##  v1 = n;
##  v2 = 0;
##  while (v1 > 0)
##  {
##    if (v2 < m)
##    {
##      v2 = v2 + 1;
##      v1 = v1 - 1;
##    }
##    else
##    {
##      v2 = 0;
##    }
##  }
##}
## 111
##
!vars
n m v1 v2

!pvars
n' m' v1' v2'

!path
#n>=0
#m>=1
#v1=n
#v2=0
v1>=1
v2<=m-1
v2'=v2+1
v1'=v1-1
m'=m
n'=n

!path
#n>=0
#m>=1
#v1=n
#v2=0
v1>=1
v2>=m
v2'=0
m'=m
n'=n
v1'=v1
