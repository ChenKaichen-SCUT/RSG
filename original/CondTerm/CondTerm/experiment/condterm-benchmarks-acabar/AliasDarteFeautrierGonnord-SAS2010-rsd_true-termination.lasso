##if (_r >= 0) {
##	da = 2 * _r;
##	db = 2 * _r;
##	while (da >= _r) {
##		if (_nondet_2()) {
##			da = da - 1;
##		} else {
##			da = db - 1;
##			db = da;
##		}
##	}
##}
## 111
##
!vars
r da db

!pvars
r' da' db'

!path
#r>=0
#da=2*r
#db=2*r
da>=r
da'=da-1
db'=db
r'=r

!path
#r>=0
#da=2*r
#db=2*r
da<=r-1
da'=db-1
db'=db-1
r'=r

