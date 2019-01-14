# Privacy

The source for this challenge is

```
pragma solidity ^0.4.18;

contract Privacy {

  bool public locked = true;
  uint256 public constant ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(now);
  bytes32[3] private data;

  function Privacy(bytes32[3] _data) public {
    data = _data;
  }

  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}
```

To solve the challenge we need to call the `unlock` function
with the correct `_key` parameter.

As we learned on the [Vault](../vault/README.md) challenge we
can read the storage of a smart contract easily. We are going
to use the same [script](index.js) that we used in that challenge.
The `8` first slots of the storage looks like this

```
0x000000000000000000000000000000000000000000000000000000dbdaff0a01
0x01473a77b8711a91911e43f09ef2f70ff0724ee5407f3e8ca11f18ac03db3f4b
0x0fd4eb2c2da8d49df6dca5ed7885f44d10b00769d0eb51d503d63998a6c763fa
0x15bf93d14648ecbe9521ce0cdf5aa5f50f2671674217a872a4f86a59445ec28c
0x0000000000000000000000000000000000000000000000000000000000000000
0x0000000000000000000000000000000000000000000000000000000000000000
0x0000000000000000000000000000000000000000000000000000000000000000
0x0000000000000000000000000000000000000000000000000000000000000000
```

This looks weird because the `3` last slots are empty and this should
correspond to the `data` global variable but this is expected because
storage optimizations.

First of all `constants` are not stored in the storage so the `ID`
variable should be discarted. Also each storage slot has `32 bytes`
and if we store variables that are smaller than this they are packed
in one slot. So the variables `locked`, `flattening`, `denomination`
and `awkwardness` are stored in one single slot, in this case the
slot `0x00`. Then the `data` variable is stored in the `3` next slots
`0x01`, `0x02` and `0x03`.

`data[2]` corresponds to the `0x03` storage slot so to solve this challenge
we need to get the first `16 bytes` of this slot `0x15bf93d14648ecbe9521ce0cdf5aa5f5`
and then

```
contract.unlock("0x15bf93d14648ecbe9521ce0cdf5aa5f5");
```