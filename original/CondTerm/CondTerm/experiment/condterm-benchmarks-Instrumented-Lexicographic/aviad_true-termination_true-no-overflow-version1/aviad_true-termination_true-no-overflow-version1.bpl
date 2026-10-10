function {:existential true} b0(a:int %FD%, TR1:int, TR2:int, TR3:int, ATTM$a_MOD_2:int, ATTM$a_MOD_3:int): bool;
function {:existential true} b1(a:int): bool;

procedure main()
{
  var a %VD%, TR1, TR2, TR3: int;
  havoc a;
  
  %BE%
TR1 := 0;
TR2 := 0;
TR3 := 0;
  	
  while (a > 1)
  invariant b0(a %IC%, TR1, TR2, TR3, a mod 2, a mod 3);
  rec b1(a)
  {
    %BT%
TR1 := 0;
TR2 := 0;
TR3 := 0;
    
    if(a mod 2 == 0){
TR1 := 1;
      a := a div 2;
    }
    else if(a mod 3 == 0){
TR2 := 1;
        a := a div 3;
    }
    else {
TR3 := 1;
      a := a + 1;
    }
    %IT%
  }
}
