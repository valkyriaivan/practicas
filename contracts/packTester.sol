pragma solidity ^0.4.21;
import "./cardFactory.sol";

contract Random is cardFactory{

    event errorBuy(bytes29);

    modifier canBuy {
        if (now >= ownerCooldown[msg.sender]) {
            _;
        } else{
            emit errorBuy("No ha finalizado tu cooldown.");
        }
    }
    function _random() private view returns (uint randomNumber) {
        uint randomHash = uint256(keccak256(block.difficulty, block.timestamp, blockhash(block.number-1)));
        return randomHash;
    }

    function packTester(uint16 year) public canBuy {
        uint numRand = _random();
        uint delimitador = 10000000;
        uint8 tier;

        for(uint8 i = 0; i < 10; i++){
            ownerCooldown[msg.sender] = now + 30 seconds;
            uint8 tierScope = uint8((numRand/(delimitador**(i+1)))%100);

            if (tierScope <=50) tier = 1;
            else if (tierScope<=75) tier = 2;
            else if (tierScope<=90) tier = 3;
            else tier = 4;
            i++;

            _createTokenPlayer(uint16(tierListTest[year][tier][(numRand/(delimitador*(i+1)))%tierCardCount[tier]-1]));
        }
    }
}
