# Hello ethernaut

To solve this level we can view the contract source [here](https://github.com/OpenZeppelin/ethernaut/blob/6ec165f199d8db65ba32c0b5b3519e5481b66af3/contracts/levels/Instance.sol).

Notice that to change the `cleared` variable we need to call the `authenticate` method with the correct passphrase.

```
function authenticate(string passkey) public {
    if(keccak256(passkey) == keccak256(password)) {
      cleared = true;
    }
}
```

Also notice that the `password` global variable is `public` and his value is set when the contract is created.

```
string public password;

// ...

function Instance(string _password) public {
    password = _password;
}
```

To get the password we need to run `contract.password()`. This will return `ethernaut0` so running `contract.authenticate("ethernaut0")` solves this level.
