##if (y1 >= 0 && y2 >= 0) {
##	while (y1 != y2) {
##		if (y1 > y2) {
##			y1 = y1 - y2;
##		} else {
##			y2 = y2 - y1;
##		}
##	}
##}
## 111
##
!vars
y1 y2

!pvars
y1' y2'

!path
y1>=0
y2>=0
y1>=y2+1
y1'=y1-y2
y2'=y2

!path
y1>=0
y2>=0
y1<=y2-1
y2'=y2-y1
y1'=y1
