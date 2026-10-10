function {:existential true} b0(life : int, death: int, choose: int %FD%, TR1:int): bool;
function {:existential true} b1(life : int, death: int, choose: int): bool;

procedure main()
{
  var choose: int;
  var life: int;
  var death: int;
  var temp %VD%, TR1: int;

  choose := 2;
  life := 13;
  death := 17;

  %BE%
  TR1 := 0;

  while (life < death)
    invariant b0(life, death, choose %IC%, TR1);
    rec b1(life, death, choose)
  {
    %BT%
	TR1 := 0;
    temp := death;
    death := life + 1;
    life := temp;

    if (choose < life || choose < death) {
      TR1 := 1;
        life := choose;
    }

    %IT%
  }

  return;
}
