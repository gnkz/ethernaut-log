# Naught coin

The source for this challenge is

```
pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

 contract NaughtCoin is StandardToken {

  string public constant name = 'NaughtCoin';
  string public constant symbol = '0x0';
  uint public constant decimals = 18;
  uint public timeLock = now + 10 years;
  uint public INITIAL_SUPPLY = 1000000 * (10 ** decimals);
  address public player;

  function NaughtCoin(address _player) public {
    player = _player;
    totalSupply_ = INITIAL_SUPPLY;
    balances[player] = INITIAL_SUPPLY;
    Transfer(0x0, player, INITIAL_SUPPLY);
  }
  
  function transfer(address _to, uint256 _value) lockTokens public returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(now > timeLock);
      _;
    } else {
     _;
    }
  } 
}
```

We start with `1000000000000000000000000` tokens and the challenge is to
transfer all of them to other account. The catch is that the `transfer`
function is locked by the `lockTokens` modifier.

Notice that the `NaughtCoin` contract is extending the `StandardToken`.
We can found the source of this contract
[here](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.3.0/contracts/token/StandardToken.sol).
The `StandardToken` has other functions and we can use these functions
in the `NaughtCoin` contract. So, we can use the function `transferFrom`
because this function is not locked but first we need to call the
`approve` function. To understand what these functions do read
[this](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md).

```
contract.approve(your_ethernaut_address, "1000000000000000000000000")
```

```
contract.transferFrom(your_ethernaut_address, other_address, "1000000000000000000000000")
```
