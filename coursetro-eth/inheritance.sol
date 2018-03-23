pragma solidity ^0.4.0;

contract LastWill {
    
    address owner;
    string mess = "";
    
    uint256 public lastTouch;
    
    address[] public childs;
    
    event Status(string _msg);
    
    function LastWill() payable public {
        owner = msg.sender;
        lastTouch = block.timestamp;
        emit Status('Last Will Created');
    }
    
    function depositFunds() payable public {
        emit Status('Funds Deposited');
    }
    
    function stillAlive() public {
        lastTouch = block.timestamp;
        emit Status('I Am Still Alive!');
    }
    
    function isDead() public {
        emit Status('Asking if dead');
        if(block.timestamp > (lastTouch + 120)) {
            giveMoneyToChilds();
        } else {
            emit Status('I Am still Alive!');
        }
    }
    
    function giveMoneyToChilds() private {
        emit Status('I am dead, take my money');
        uint amountPerChild = address(this).balance/childs.length;
        for(uint i = 0; i < childs.length; i++) {
            childs[i].transfer(amountPerChild);
        }
    }
    
    function addChild(address _address) onlyOwner public {
        emit Status('Child Added');
        childs.push(_address);
    }
    
    modifier onlyOwner {
		if (msg.sender != owner) {
			revert();
		} else {
			_;
		}
	}
}
