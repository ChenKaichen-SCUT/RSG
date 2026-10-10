##j = t;    
##while (t > 0) {
##    if (t >= j) {
##        t = t+1;
##        if (j < 5) {
##            j = j+1;
##            if (t-j>2) {
##                t = t+1;   1
##            } else {
##                j = j+1;
##            }
##        } else {
##            j = j-1;
##        }
##    } else {
##        if (t > 0 && j < 0) {
##            t = t-1;
##            if (j < -1) {
##                j = j+1;
##            } else {
##                t = t+1;
##            }
##        } else {
##            t = t+1;
##            if (j*2 > t) {
##                j = j-1;
##            } else {
##                j = j+1;
##            }
##        }
##    }        
##}
## 111
##
!vars
j t

!pvars
j' t'

!path
#j=t
t>=1
t>=j
j<=4
j'=j+1
t-j>=3
t'=t+2

!path
#j=t
t>=1
t>=j
j<=4
t-j<=2
t'=t+1
j'=j+2

!path
#j=t
t>=1
t>=j
t'=t+1
j>=5
j'=j-1

!path
#j=t
t>=1
t<=j-1
t>=1
j<=-1
t'=t-1
j<=-2
j'=j+1

!path
#j=t
t>=1
t<=j-1
t>=1
j<=-1
j>=-1
t'=t
j'=j


!path
#j=t
t>=1
t<=j-1
t<=0
t'=t+1
j*2>=t+1
j'=j-1

!path
#j=t
t>=1
t<=j-1
t<=0
t'=t+1
j*2<=t
j'=j+1

!path
#j=t
t>=1
t<=j-1
j>=0
t'=t+1
j*2>=t+1
j'=j-1

!path
#j=t
t>=1
t<=j-1
j>=0
t'=t+1
j*2<=t
j'=j+1
