pragma solidity ^0.4.21;
import "./cardFactory.sol";

contract Random is cardFactory{
    
    // event NewPack(address packOwner, uint16[] packNew);    
    function _random() private view returns (uint randomNumber) {
        return uint256(keccak256(block.difficulty, block.timestamp, blockhash(block.number-1)));
    }
  
    function packTester(uint16 year) public returns (uint16[]) {
        uint numRand = _random();
        uint delimitador = 10000000;
        uint8 tier;
        uint16[] memory pack = new uint16[](5);
        uint8 t = 0;
        
        for(uint8 i = 0; i < 10; i++){
            // ownerCooldown[msg.sender] = now + 30 seconds;
            uint8 tierScope = uint8((numRand/(delimitador**(i+1)))%100);
            
            if (tierScope <=50) tier = 1;
            else if (tierScope<=75) tier = 2;
            else if (tierScope<=90) tier = 3;
            else tier = 4;
            i++;
            
            uint16 idCard = uint16(tierListTest[year][tier][(numRand/(delimitador*(i+1)))%tierCardCount[tier]-1]);
            pack[t] = idCard;
            t++;
            _createTokenPlayer(idCard);
        }
        // emit NewPack(pack);
    }

}
