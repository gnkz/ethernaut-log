# Force

The source for this challenge is

```
pragma solidity ^0.4.18;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}
```

Yup, that's all. To win this challenge we need to somehow transfer some ether
to the `Force` contract. We could do it by simply sending a transaction to this
contract but for this it should have a `fallback` function with the `payable`
modifier and we are not so lucky.

The other option and the actual solution to this challenge is to create a contract
that holds some ether and then call the `selfdestruct` function. This function accepts
an address as parameter and what is does is to transfer all the contract balance to this
address. A contract that can do this is [ForceTransfer](ForceTransfer.sol).

To solve this get the challenge instance address from the console. Then deploy the
[ForceTransfer](ForceTransfer.sol) contract using the instance address as a parameter
and sending along at least `1 wei`. Then call the `hax` function from
[ForceTransfer](ForceTransfer.sol) and that's it.
