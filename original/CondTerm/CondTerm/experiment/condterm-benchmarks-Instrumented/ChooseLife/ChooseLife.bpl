function {:existential true} b0(life : int, death: int, choose: int, i:int %Decl:i%): bool;
function {:existential true} b1(life : int, death: int, choose: int): bool;

procedure main()
{
  var choose: int;
  var life: int;
  var death: int;
  var temp, i: int;

  choose := 2;
  life := 13;
  death := 17;

  assume(%M:i%);

  while (life < death)
    invariant b0(life, death, choose,i %Inv:i%);
    rec b1(life, death, choose)
  {
    %assert(i > 0);%
    temp := death;
    death := life + 1;
    life := temp;

    if (choose < life || choose < death) {
        life := choose;
    }

    %i := i - 1;%
  }

  return;
}
