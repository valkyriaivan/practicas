pragma solidity ^0.4.4;

contract Random {
  uint _seed;
  uint randomHash;
  uint numRand;
  uint delimitador;
  uint i;
  uint16 tierScope;
  uint8 tier;
  
  event testSeed(uint num);
  event testRandom(uint[]  num);
  
  mapping (uint => mapping (uint => uint[])) public tierList;

  function random() public returns (uint randomNumber) {
    // _seed = uint256(keccak256(keccak256(keccak256(block.blockhash(block.number), _seed), now), block.timestamp));
    randomHash = uint256(keccak256(block.difficulty, block.timestamp, now, block.blockhash(block.number)));
    // emit testSeed(_seed);
    return randomHash;
  }
  
  function packTester(uint year) public returns (uint[]) {
    numRand = random();
    delimitador = 10000000;
    uint[] storage pack;
    
    for(i = 0; i < 10; i++){
        tierScope = uint16((numRand/(delimitador*(i+1)))%100);
        
        if (tierScope>=0 && tierScope <=70) tier = 0;
        else if (tierScope>=71 && tierScope<=91) tier = 1;
        else if (tierScope>=92 && tierScope<=98) tier = 2;
        else if (tierScope == 99) tier = 3;
        // emit testSeed(tierTest);
        i++;
        pack.push((numRand/(delimitador*(i+1)))%tierList[year][tier].length-1);
    }
    return pack;
  }
}
