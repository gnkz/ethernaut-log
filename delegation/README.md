# Delegation

The source for this challenge is

```
pragma solidity ^0.4.18;

contract Delegate {

  address public owner;

  function Delegate(address _owner) public {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  function Delegation(address _delegateAddress) public {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  function() public {
    if(delegate.delegatecall(msg.data)) {
      this;
    }
  }
}
```

To win this challenge we need to take ownership of the `Delegation` contract. To do this we are going to use the `fallback` function from this contract. What this function does is to call `delegatecall` on the `Delegate` contract. Wen you use `delegatecall` the target contract will get access to the state from the origin contract. So using the `delegatecall` to call the `pwn` function from `Delegate` will change the owner of `Delegation`.

To call the `fallback` function from `Delegation` we can simply send a transaction using metamask but how can we tell the transaction to call the `pwn` function from `Delegate`?
We need to use a function identifier. To get the function identifier of `pwn`

```
hash = keccack256("pwn()") // Get the keccak256 hash of the string "pwn()"
identifier = first4Bytes(hash) // Get the 4 first bytes of the hash
```

In our case the identifier will be `dd365b8b`. Include this on the transaction and this will call the `pwn` function giving you ownership of `Delegation`.
