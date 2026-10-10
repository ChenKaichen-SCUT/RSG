function {:existential true} b0(K:int, x:int, i:int %Decl:i%): bool;
function {:existential true} b1(x:int, K:int): bool;

procedure main()
{
  var K,x,i: int;
  havoc K;
  havoc x;
  
  assume(%M:i%);
  	
  while (x != K)
  invariant b0(K,x,i %Inv:i%);
  rec b1(x, K)
  {
    %assert(i > 0);%
    if(x > K){
        x := x - 1;
    }
    else{
        x := x + 1;
    }
    %i := i - 1;%
  }
}
