function {:existential true} b0(_i:int, j:int, k:int, an:int, bn:int, tk:int, i:int %Decl:i%): bool;
function {:existential true} b1(an:int, _i:int, bn:int, j:int, k:int, tk:int): bool;

procedure main()
{
  var _i,j,k,an,bn,tk,i: int;
  havoc _i;
  havoc j;
  havoc k;
  havoc an;
  havoc bn;
  havoc tk;

  assume(%M:i%);

  while (((an >= _i && bn >= j) || (an >= _i && bn <= j) || (an <= _i && bn >= j)) && k >= tk + 1)
  invariant b0(_i,j,k,an,bn,tk,i %Inv:i%);
  rec b1(an,_i,bn,j,k,tk)
  {
	%assert(i > 0);%
	if (an >= _i && bn >= j) {
		if (*) {
			j := j + k;
			tk := k;
			havoc k;
		} else {
			_i := _i + 1;
		}
	} else {if (an >= _i && bn <= j) {
		_i := _i + 1;
	} else {if (an <= _i && bn >= j) {
		j := j + k;
		tk := k;
		havoc k;
	}}}
	%i := i - 1;%
  }
}
