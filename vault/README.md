# Vault

The source for this challenge is

```
pragma solidity ^0.4.18;

contract Vault {
  bool public locked;
  bytes32 private password;

  function Vault(bytes32 _password) public {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}
```

In order to beat this challenge we need to set the `locked` variable to false.
To do this we need to call the `unlock` function with the correct `password`.
Notice that the `password` variable is set on the `constructor` of the contract,
so we can get the contract creation transaction and get the data payload that
was used. The data payload used to create the contract was

```
0xdfc86b17000000000000000000000000e77b0bea3f019b1df2c9663c823a2ae65afb6a5f
```

The first 4 bytes of this data payload correspond to a function identifier while
the rest of it should be the `password` variable.

To solve the challenge call

```
contract.unlock("0x000000000000000000000000e77b0bea3f019b1df2c9663c823a2ae65afb6a5f")
```

