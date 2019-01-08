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
As you know ethereum is a public blockchain and because of this using the
correct tools we can read the state of a contract. Marking a variable as private
doesn't prevent us to read it from the state.

To read the storage we are going to use [ethers.js](https://github.com/ethers-io/ethers.js/).
The script can be found in [index.js](index.js) but the important piece of code
is

```
  const stored = await provider.getStorageAt(target, 1);
```

With this code we are reading the second storage variable (0 would be the first)
in the target contract.

The result is

```
0x412076657279207374726f6e67207365637265742070617373776f7264203a29
```

To solve the challenge call

```
contract.unlock("0x412076657279207374726f6e67207365637265742070617373776f7264203a29")
```

