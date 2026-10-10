##_i = N;
##while (_i > 0) {
##	if (j > 0) {
##		j = j - 1;
##	} else {
##		j = N;
##		_i = _i - 1;
##	}
##}
##return 0;
## 111
##
!vars
i j N

!pvars
i' j' N'

!path
#i=N
i>=1
j>=1
j'=j-1
i'=i
N'=N

!path
#i=N
i>=1
j<=0
j'=N
i'=i-1
N'=N
