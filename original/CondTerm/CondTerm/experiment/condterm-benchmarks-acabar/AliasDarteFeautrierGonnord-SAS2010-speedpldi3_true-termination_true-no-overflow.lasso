##if (m > 0 && n > m)
##{
##  _i = 0;
##  j = 0;
##  while (_i < n)
##  {
##    if (j < m)
##    {
##      j = j + 1;
##    }
##    else
##    {
##      j = 0;
##      _i = _i + 1;
##    }
##  }
##}
## 111
!vars
m n i j

!pvars
m' n' i' j'

!path
m>=1
n>=m+1
#i=0
#j=0
i<=n-1
j<=m-1
j'=j+1
m'=m
n'=n
i'=i

!path
m>=1
n>=m+1
#i=0
#j=0
i<=n-1
j>=m
j'=0
i'=i+1
m'=m
n'=n
