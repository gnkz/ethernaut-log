# Re-entrancy

The source for this challenge is

```
pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  function() public payable {}
}
```

To solve this we need to steal all the ether from the
instance contract.

As the name of the challenge implies we need to do a 
re-entracy attack on the `Reentrance` contract. This
attack is posible because of this `(msg.sender.call.value(_amount)()`
code and the fact that the `msg.sender` balance is
being modified after checking if the `msg.sender`
has balance.

To solve the challenge

1) Get the instance contract address
2) Deploy the [Attack](Attack.sol) contract using
that the instance contract address as a parameter
3) Use the `donate` function to donate `0.5 ether` to the
attack contract
4) Call the `hax` function of the [Attack](Attack.sol)
contract with a high `gasLimit`

Don't forget to call the `kill` function of the
[Attack](Attack.sol) contract to recover your
ether.

