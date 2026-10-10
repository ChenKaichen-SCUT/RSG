function {:existential true} b0(a:int, i:int %Decl:i%): bool;
function {:existential true} b1(a:int): bool;

procedure main()
{
  var a,i: int;
  havoc a;
  
  assume(%M:i%);
  	
  while (a > 1)
  invariant b0(a,i %Inv:i%);
  rec b1(a)
  {
    %assert(i > 0);%
    
    if(a mod 2 == 0){
      a := a div 2;
    }
    else {
      a := a - 1;
    }
    %i := i - 1;%
  }
}
