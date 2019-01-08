# Denial

The source for this challenge is

```
pragma solidity ^0.4.24;

contract Denial {

    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = 0xA9E;
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance/100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call.value(amountToSend)();
        owner.transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = now;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    function() payable {}

    // convenience function
    function contractBalance() view returns (uint) {
        return address(this).balance;
    }
}
```

The objective is to prevent the owner to get his share when
calling the `withdraw` function.

My first approach was to create a contract with a fallback
function that performs a maximum stack depth attack but I
didn't succeed because even with a really high `gasLimit`
I never reached the maximum stack depth.

My second approach was to do something similar to the
[King](../king/README.md) challenge. In this case using
a `revert` won't work because the return of
`partner.call.value(amoutToSend)()` is not being checked.
Reading the [documentation](https://solidity.readthedocs.io/en/v0.4.24/control-structures.html#error-handling-assert-require-revert-and-exceptions)
I realized that an `assert` exception will consume all the
gas available and `partner.call.value(amountToSend)();` is
not using a gas limit, so the fallback function will receive
all the gas. Then generating an `assert` exception will
consume all the gas and this will prevent that any code after
this will be run`. The contract used was [Attack](Attack.sol).
