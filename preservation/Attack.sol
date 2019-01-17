pragma solidity ^0.4.23;

contract Attack {
    uint256[3] public data;

    function setTime(uint _time) public {
        data[2] = _time;
    }
}