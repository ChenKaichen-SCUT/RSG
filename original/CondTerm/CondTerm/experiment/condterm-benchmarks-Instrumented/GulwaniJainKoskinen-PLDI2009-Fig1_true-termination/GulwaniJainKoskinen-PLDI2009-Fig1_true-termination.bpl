function {:existential true} b0(id:int, maxId:int, tmp:int, i:int %Decl:i%, ATTM$i$ADD$tmp:int): bool;
function {:existential true} b1(tmp:int, id:int, maxId:int): bool;

procedure main()
{
  var id, maxId, tmp, i: int;
  havoc id;
  havoc maxId;

  assume(0 <= id && id < maxId);
  tmp := id + 1;
  assume(%M:i%);

  while (tmp != id)
  invariant b0(id, maxId, tmp, i %Inv:i%, i + tmp);
  rec b1(tmp, id, maxId)
  {
    %assert(i > 0);%
    if (tmp <= maxId)
    {
        tmp := tmp + 1;
    }
    else
    {
        tmp := 0;
    }
    %i := i - 1;%
  }
}
