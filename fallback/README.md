# Fallback

This is the source for this level

```
pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract Fallback is Ownable {

  mapping(address => uint) public contributions;

  function Fallback() public {
    contributions[msg.sender] = 1000 * (1 ether);
  }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    owner.transfer(this.balance);
  }

  function() payable public {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}
```

To solve this level we need to get the ownership of the contract and draw all the ether from it.

To get ownership we need to set the `owner` variable to our ethereum address and then call the `withdraw()` function to empty the contract.

To get ownership we have 2 options:

1) Call the `contribute()` function till the condition `contributions[msg.sender] > contributions[owner]` is `true`. Reading the contract source we can see that the `owner` starts with `1000 ether` in contributions and that we can contribute only a value less than `0.001 ether` each time. So this options will take a lot of ether, transactions and time.
2) Call the fallback function. You can read about fallback functions [here](https://solidity.readthedocs.io/en/v0.4.21/contracts.html#fallback-function). This function will be executed if a transaction to the contract doesn't call any of the contract functions but there is a catch. The fallback function has a condition that must be satisfied: `require(msg.value > 0 && contributions[msg.sender] > 0);`. This means that we need to call the `contribute()` function at least once and that we need to send at least `1 wei` to the contract.

So, first of all we need to call the `contribute` function

```
contract.contribute({ value: "1" }) // We pass an object to tell metamask that we want to send 1 wei with this transaction
```

Then we send a transaction with at least `1 wei` to the contract address using metamask.

You can confirm that your are the owner now by calling `contract.owner()`.

Lastly, to get all the ether we need to call `contract.withdraw()` and then submit the instance to complete the level.
