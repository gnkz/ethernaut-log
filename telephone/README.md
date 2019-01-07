# Telephone

The source for this level is

```
pragma solidity ^0.4.18;

contract Telephone {

  address public owner;

  function Telephone() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}
```

To solve this we need to understand the difference between `tx.origin` and `msg.sender`.

- `tx.origin` represents the address of the external owned account that started the transaction.
- `msg.sender` is the address of the direct caller of the contract. This address can be from an external owned account or from other contract.

If we call the function `changeOwner` the `tx.origin` and `msg.sender` variables will be the same because the account that started the transaction is also the direct caller for that function. So to solve this we need to create a proxy contract that calls the `changeOwner` function for us. In this way the `tx.origin` will be your address and `msg.sender` will be the address of this proxy contract. An example of a proxy contract is [TelephoneProxy](TelephoneProxy.sol).

First of all deploy a new instance of the level and take note of the instance address. Then deploy a proxy like [TelephoneProxy](TelephoneProxy.sol) and pass the instance address as a parameter. Lastly call the `hax` function from the [TelephoneProxy](TelephoneProxy.sol) with your address as parameter. This is going to call the `changeOwner` function and your address will be the owner.
