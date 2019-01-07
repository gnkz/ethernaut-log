# King

The source for this challenge is

```
pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract King is Ownable {

  address public king;
  uint public prize;

  function King() public payable {
    king = msg.sender;
    prize = msg.value;
  }

  function() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }
}
```

This is similar to a real hack that happened to "King of the ether".
To beat this challenge we need to create a contract that once is set
as the king, the `king.transfer(msg.value);` code will always fail.
The [TrueKing](TrueKing.sol) contract does this with this `fallback`
function

```
function() public payable {
    revert();
}
```

This function reverts everytime there is a transfer to the contract.

Get the instance address from the console and then deploy the
[TrueKing](TrueKing.sol) contract with the address as a parameter.
Then call the `hax` function and finally submit the instance.
