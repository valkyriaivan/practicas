pragma solidity ^0.4.21;

import "./ownable.sol";

contract cardFactory is Ownable{

    event NewCard(uint tokenId, string name);
    event testSeed(address num);

    struct Player {
        bytes24 name;
        uint16 year;
        uint16 idPlayer;
        uint16 idTeam;
        uint8 tier;
    }
    Player[] public players;

    struct Team {
        bytes16 name;
        uint16 year;
        uint16 idTeam;
    }
    Team[] public teams;

    struct tokenPlayer {
        uint16 idPlayer;
    }
    tokenPlayer[] public tokenPlayers;

    struct tierTest {
        uint16 idPlayer;
    }

    mapping (uint => mapping (uint => mapping (uint => uint))) public tierListTest;
    mapping (uint => uint) public tierCardCount;


    // mapping (uint => uint) public playerToTeam;
    // mapping (uint => uint) public tokenToPlayer;
    mapping (uint => address) public cardToOwner;
    mapping (address => uint) public ownerCardCount;
    mapping (address => uint) public ownerCooldown;

    constructor() public {
        _createTeam("barcelona",2018);

        for(uint8 i = 1;i<5; i++){
            for(uint8 n = 0;n<5;n++){
                _createPlayer("Messi",2018,i,0);
            }
        }
    }


    function _createPlayer(bytes24 _name, uint16 _year, uint8 _tier, uint16 _team) public onlyOwner {
        uint16 _idPlayer = uint16(players.push(Player(_name, _year, uint16(players.length), _team, _tier)));
        // playerToTeam[_idPlayer] = _team;

        // uint length = tierList[_year][_tier].length-1;

        tierListTest[_year][_tier][tierCardCount[_tier]] = _idPlayer;
        tierCardCount[_tier]++;
    }

    function _createTeam(bytes16 name, uint16 year) public onlyOwner {
        // uint256 idTeam = teams.length;
        teams.push(Team(name, year, uint16(teams.length)));
    }

    function _createTokenPlayer(uint16 _idPlayer) public {
        // uint256 _idTokenPlayer = tokenPlayers.length;
        uint id = tokenPlayers.push(tokenPlayer(_idPlayer));

        cardToOwner[id-1] = msg.sender;
        ownerCardCount[msg.sender]++;
        // tokenToPlayer[id-1] = _idPlayer;
        // emit NewCard(id, players[_idPlayer].name);
    }


    function getTokenToPlayer(uint tokenId) public view returns (uint) {
        return tokenPlayers[tokenId].idPlayer;
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

    function getCardsByOwner(address _owner) public view returns (uint[]) {
        uint[] memory result = new uint[](ownerCardCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < tokenPlayers.length; i++) {
          if (cardToOwner[i] == _owner) {
            result[counter] = tokenPlayers[i].idPlayer;
            counter++;
          }
        }
        return result;
    }

    function getTeamsByYear(uint16 year) public view returns (uint16[]) {
        // uint[] memory result = new uint[](20);

        uint16 counter = 0;
        for (uint16 i = 0; i < teams.length; i++) {
          if (teams[i].year == year) {
            // result[counter] = players[i].idPlayer;
            counter++;
          }
        }
        uint16[] memory result = new uint16[](counter);
        counter = 0;
        for (i = 0; i < teams.length; i++) {
          if (teams[i].year == year) {
            result[counter] = i;
            counter++;
          }
        }
        return result;
    }

    function getPlayersByTeam(uint16 team) public view returns (uint16[]) {
        // uint[] memory result = new uint[](20);

        uint16 counter = 0;
        for (uint16 i = 0; i < players.length; i++) {
          if (players[i].idTeam == team) {
            // result[counter] = players[i].idPlayer;
            counter++;
          }
        }
        uint16[] memory result = new uint16[](counter);
        counter = 0;
        for (i = 0; i < players.length; i++) {
          if (players[i].idTeam == team) {
            result[counter] = players[i].idPlayer;
            counter++;
          }
        }
        return result;
    }
    function getCardTotal() public view returns (uint[]) {
        uint[] memory result = new uint[](getCardsLength());
        uint counter = 0;
        for (uint i = 0; i < players.length; i++) {
            result[counter] = i;
            counter++;
        }
        return result;
    }

    function getCardsLength() public view returns (uint) {
        return players.length;
    }

}
