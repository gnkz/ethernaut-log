# Elevator

The source for this challenge is

```
pragma solidity ^0.4.18;


interface Building {
  function isLastFloor(uint) view public returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}
```

To win this challenge we need to set the `top` variable to `true`.
To do this we need to call the `goTo` function but the `building.isLastFloor`
need to return `false` in the first call and `true` in the last call.
The `Building` interface says that the `isLastFloor` function should
not modify the state by putting a `view` modifier. Sadly this check is done
only at compile time and we can create a contract that has the `isLastFloor`
function without that modifier. The [FakeBuilding](FakeBuilding.sol) contract
is an example of that. With this contract we can call the `goTo` function
on the `Elevator` and the `isLastFloor` will be `false` on the first call
and `true` on the second call, setting the `top` variable to `true` and solving
the challenge.
