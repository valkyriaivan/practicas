pragma solidity ^0.4.21;
import "./cardFactory.sol";

contract Random is cardFactory{
  uint _seed;
  uint randomHash;
  uint numRand;
  uint delimitador;
  uint i;
  uint16 tierScope;
  uint8 tier;
  uint8 incr = 0;
  
  event testSeed(uint num);
  event testRandom(uint[]  num);
  
//   mapping (uint => mapping (uint => uint[])) public tierList;

  function random() public returns (uint randomNumber) {
    // _seed = uint256(keccak256(keccak256(keccak256(block.blockhash(block.number), _seed), now), block.timestamp));
    randomHash = uint256(keccak256(block.difficulty, block.timestamp, now, block.blockhash(block.number)));
    // emit testSeed(_seed);
    return randomHash;
  }
  
  function packTester(uint year) public {
    numRand = random();
    delimitador = 10000000;
    // uint[] memory pack = new uint[](5);
    
    for(i = 0; i < 10; i++){
        tierScope = uint16((numRand/(delimitador**(i+1)))%100);
        emit testSeed(tierScope);
        
        if (tierScope <=70) tier = 1;
        else if (tierScope<=91) tier = 2;
        else if (tierScope<=98) tier = 3;
        else tier = 4;
        i++;
        
        _createTokenPlayer(tierListTest[year][tier][(numRand/(delimitador*(i+1)))%tierCardCount[tier]-1]);
    }
  }
}
