# Coin flip

The source contract for this level is

```
pragma solidity ^0.4.18;

contract CoinFlip {
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function CoinFlip() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(block.blockhash(block.number-1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}
```

To solve this we need to set the `consecutiveWins` global variable to `10`. For this wee need to guess the result from this part of the code

```
uint256 coinFlip = blockValue / FACTOR;
bool side = coinFlip == 1 ? true : false;
```

Luckly the value of `FACTOR` is known and the value of `blockValue` can be obtained easily using a library like `web3.js` or simply using a solidity smart contract. We are going to use the later in this case.

First of all get a new instance of the level and save the instance address. Then go to Remix IDE and copy and paste the code from [CoinflipGuesser]() and deploy it with the instance address as a parameter. Then use the `hax()` function from the [CoinflipGuesser]() to always guess correctly. We can do this only once per block because of this code 

```
if (lastHash == blockValue) {
  revert();
}

lastHash = blockValue;
```

Once the `consecutiveWins` global variable goes to `10` submit the instance to solve the level.
