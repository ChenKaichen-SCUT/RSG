##if (x > 0)
##{
##    while (x != 0)
##    {
##        x = x - 1;
##    }
##}
## 111
##
!vars
x

!pvars
x'

!path
#x>=1
x>=1
x'=x-1

!path
#x>=1
x<=-1
x'=x-1
