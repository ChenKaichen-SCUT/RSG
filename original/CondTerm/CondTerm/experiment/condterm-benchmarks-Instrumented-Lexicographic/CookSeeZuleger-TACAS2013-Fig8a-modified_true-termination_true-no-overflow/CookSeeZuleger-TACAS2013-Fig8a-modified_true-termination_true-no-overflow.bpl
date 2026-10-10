function {:existential true} b0(K:int, x:int %FD%, TR1:int, TR2:int): bool;
function {:existential true} b1(x:int, K:int): bool;

procedure main()
{
  var K,x %VD%, TR1, TR2: int;
  havoc K;
  havoc x;
  
  %BE%
TR1 := 0;
TR2 := 0;
  	
  while (x != K)
  invariant b0(K,x %IC%, TR1, TR2);
  rec b1(x,K)
  {
    %BT%
TR1 := 0;
TR2 := 0;
    if(x > K){
TR1 := 1;
        x := x - 1;
    }
    else{
TR2 := 1;
        x := x + 1;
    }
    %IT%
  }
}
