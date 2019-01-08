# Locked

The source for this challenge is

```
pragma solidity ^0.4.23; 

// A Locked Name Registrar
contract Locked {

    bool public unlocked = false;  // registrar locked, no name updates
    
    struct NameRecord { // map hashes to addresses
        bytes32 name; // 
        address mappedAddress;
    }

    mapping(address => NameRecord) public registeredNameRecord; // records who registered names 
    mapping(bytes32 => address) public resolve; // resolves hashes to addresses
    
    function register(bytes32 _name, address _mappedAddress) public {
        // set up the new NameRecord
        NameRecord newRecord;
        newRecord.name = _name;
        newRecord.mappedAddress = _mappedAddress; 

        resolve[_name] = _mappedAddress;
        registeredNameRecord[msg.sender] = newRecord; 

        require(unlocked); // only allow registrations if contract is unlocked
    }
}
```

To solve the challenge we need to set the `unlocked` variable to `true`.
The only function available to call is `register` so the only way to
change the `unlocked` variable must be in this function.

When you initialize a struct variable like `newRecord` by default it will
reference the storage and the first property on this struct will reference
the storage at `0x0`. This means that if we pass a `true` on the `_name`
variable it will actually modify the `unlocked` variable because this
is at storage `0x0`. In order to solve this run

```
contract.register("0x0000000000000000000000000000000000000000000000000000000000000001", "0x0000000000000000000000000000000000000000")
```
