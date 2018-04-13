pragma solidity ^0.4.21;

import "./ownable.sol";

contract cardFactory is Ownable{
    
    event NewCard(uint tokenId, string name);
    event testSeed(uint num);
    
    struct Player {
        string name;
        uint256 id;
        uint32 year;
        uint8 tier;
    }
    Player[] public players;
    
    struct Team {
        string name;
        uint256 id;
        uint32 year;
    }
    Team[] public teams;
    
    struct tokenPlayer {
        uint256 idToken;
        uint256 idPlayer;
    }
    tokenPlayer[] public tokenPlayers;
    
    struct tierTest {
        uint idPlayer;
    }

    mapping (uint => mapping (uint => mapping (uint => uint))) public tierListTest;
    mapping (uint => uint) public tierCardCount;


    mapping (uint => uint) public playerToTeam;
    mapping (uint => uint) public tokenToPlayer;
    mapping (uint => address) public cardToOwner;
    mapping (address => uint) public ownerCardCount;
    
    function cardFactory() public{
        _createTeam("barcelona",2018);
        
        for(uint8 i = 1;i<5; i++){
            for(uint8 n = 0;n<5;n++){
                _createPlayer("asd",2018,i,0);
            }
        }
    }
    
    
    function _createPlayer(string _name, uint32 _year, uint8 _tier, uint _team) public onlyOwner {
        uint256 _idPlayer = players.length;
        players.push(Player(_name, _idPlayer, _year, _tier));
        playerToTeam[_idPlayer] = _team;
        
        // uint length = tierList[_year][_tier].length-1;
        
        emit testSeed(tierListTest[_year][_tier][tierCardCount[_tier]] = _idPlayer);
        tierCardCount[_tier]++;
        emit testSeed(tierCardCount[_tier]);
    }
    
    function _createTeam(string name, uint32 year) public onlyOwner {
        uint256 idTeam = teams.length;
        teams.push(Team(name, idTeam, year));
    }
    
    function _createTokenPlayer(uint256 _idPlayer) public {
        uint256 _idTokenPlayer = tokenPlayers.length;
        uint id = tokenPlayers.push(tokenPlayer(_idTokenPlayer, _idPlayer));
        
        cardToOwner[id-1] = msg.sender;
        ownerCardCount[msg.sender]++;
        tokenToPlayer[id-1] = _idPlayer;
        emit NewCard(id, players[_idPlayer].name);
    }
    
    function getTokenToPlayer(uint tokenId) public view returns(uint) {
        return players[tokenToPlayer[tokenId]].id;
    }
    
    // function getTokenToTier(uint year, uint tier) public returns(uint) {
    //     // tierList[tier]
    //     uint test;
    //     for (uint i=0; i<tierList[year][tier].length; i++) {
    //         emit testSeed(tierList[year][tier][i]);
    //         test += tierList[year][tier][i];
    //     }
    //     return test;
    // }
    
    function getCardsByOwner(address _owner) public view returns(uint[]) {
        uint[] memory result = new uint[](ownerCardCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < tokenPlayers.length; i++) {
          if (cardToOwner[i] == _owner) {
            result[counter] = getTokenToPlayer(i);
            counter++;
          }
        }
        return result;
    }
    
    function getCardTotal() public view returns(uint[]) {
        uint[] memory result = new uint[](getCardsLength());
        uint counter = 0;
        for (uint i = 0; i < players.length; i++) {
            result[counter] = players[i].id;
            counter++;
        }
        return result;
    }
    
    function getCardsLength() public view returns(uint) {
        return players.length;
    }
    
}
