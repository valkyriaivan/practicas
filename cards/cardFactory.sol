pragma solidity ^0.4.19;

import "./ownable.sol";

contract cardFactory is Ownable{
    
    event NewCard(uint tokenId, string name);
    
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
    
    uint[] tier1;
    uint[] tier2;
    uint[] tier3;
    uint[] tier4;

    mapping (uint => uint) public playerToTeam;
    mapping (uint => uint) public tokenToPlayer;
    mapping (uint => address) public cardToOwner;
    mapping (address => uint) ownerCardCount;
    
    function _createPlayer(string _name, uint32 _year, uint8 _tier, uint _team) public onlyOwner {
        uint256 _idPlayer = players.length + 1;
        players.push(Player(_name, _idPlayer, _year, _tier));
        playerToTeam[_idPlayer] = _team;
        if (_tier == 1){
            tier1.push(_idPlayer);
        }
        if (_tier == 2){
            tier2.push(_idPlayer);
        }
        if (_tier == 3){
            tier3.push(_idPlayer);
        }
        if (_tier == 4){
            tier4.push(_idPlayer);
        }
    }
    
    function _createTeam(string name, uint32 year) public onlyOwner {
        uint256 idTeam = teams.length + 1;
        teams.push(Team(name, idTeam, year));
    }
    
    function _createTokenPlayer(uint256 _idPlayer) public {
        uint256 _idTokenPlayer = tokenPlayers.length + 1;
        uint id = tokenPlayers.push(tokenPlayer(_idTokenPlayer, _idPlayer));
        cardToOwner[id] = msg.sender;
        ownerCardCount[msg.sender]++;
        tokenToPlayer[id] = _idPlayer;
        // emit NewCard(id, players[_idTokenPlayer].name);
    }
    
    function getTokenToPlayer(uint tokenId) public view returns(string) {
        return players[tokenToPlayer[tokenId]].name;
    }
}
