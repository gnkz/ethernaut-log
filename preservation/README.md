# Preservation

The source for this challenge is

```
pragma solidity ^0.4.23;

contract Preservation {

  // public library contracts
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner;
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    timeZone1Library = _timeZone1LibraryAddress;
    timeZone2Library = _timeZone2LibraryAddress;
    owner = msg.sender;
  }

  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(setTimeSignature, _timeStamp);
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(setTimeSignature, _timeStamp);
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp
  uint storedTime;

  function setTime(uint _time) public {
    storedTime = _time;
  }
}
```

The objective for this challenge is to take ownership
of the instance by changing the `owner` variable to
our address.

A good article that helped me to understand how to
approach this challenge can be found
[here](https://blog.zeppelinos.org/parity-wallet-hack-reloaded/).

When we use the `delegatecall` function we are giving
access to our storage to the delegated contract. This
means that the delegated contract can modify the state
of the contract that used the `delegatecall` function.

The delegated contract doesn't know about how the storage
is structured on the other contract. In this example
the variable `storedTime` is stored in the `0x03` position
on the `Preservation` contract but is stored in the `0x00`
position in the `LibraryContract`. This means that if
we use a `delegatecall` on the `LibraryContract` this
will modify the storage variable at `0x00` in the
`Preservation` contract so it will end up changing
the `timeZone1Library` instead of the `storedTime` variable.
This means that we can create a malicious contract that
has the `setTime(uint256)` function and store his address on the
`timeZone1Library` variable and then call the `setFirstTime` function
again to execute a malicious function that modify the
`owner` variable instead. An example contract that can do
this is [Attack](Attack.sol).

In the [Attack](Attack.sol) contract we define a fixed
size array `data` and by modifying the `data[2]` variable we
are going to modify the storage variable at `0x02` on
the `Preservation` contract and thus the `owner` variable
will be modified.

Steps to solve the challenge:

1) Deploy an instance of the [Attack](Attack.sol) contract.
2) Call the `setFirstTime` function with the address of the
[Attack](Attack.sol) contract as a parameter.
3) Call the `setFirstTime` function again but this time with
your address as a parameter.