// MYVault.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./GameToken.sol";

contract MYVault {
    GameToken public immutable gameToken;

    struct Player {
        uint256 tokenHolding;
        uint256 experience;
        uint256 achievements;
        uint256 victories;
        uint256 explorationsCompleted;
        bool votingPower;
        uint256 level;
        string name;
    }

    uint256 public circulatingTokens;
    mapping(address => Player) public players;
    address[] public playerList;
    uint256 private playerCount;

    constructor(address tokenAddress) {
        gameToken = GameToken(tokenAddress);
    }

    function _mintTokens(address recipient, uint256 amount) private {
        circulatingTokens += amount;
        players[recipient].tokenHolding += amount;
    }

    function _burnTokens(address owner, uint256 amount) private {
        circulatingTokens -= amount;
        players[owner].tokenHolding -= amount;
    }

    function depositTokens(uint256 amount) external {
        uint256 tokensToAdd;
        if (circulatingTokens == 0) {
            tokensToAdd = amount;
        } else {
            tokensToAdd = (amount * circulatingTokens) / gameToken.balanceOf(address(this));
        }

        _mintTokens(msg.sender, tokensToAdd);
        gameToken.transferFrom(msg.sender, address(this), amount);
        updateRanking();
    }

    function withdrawTokens(uint256 amount) external {
        uint256 amountToWithdraw = (amount * gameToken.balanceOf(address(this))) / circulatingTokens;
        _burnTokens(msg.sender, amount);
        gameToken.transfer(msg.sender, amountToWithdraw);
        updateRanking();
    }

    function registerPlayer(string memory playerName, uint256 playerLevel, uint256 initialTokens) external {
        playerCount++;
        address playerAddress = address(uint160(playerCount));

        players[playerAddress] = Player(initialTokens, 0, 0, 0, 0, false, playerLevel, playerName);
        playerList.push(playerAddress);

        // Simulate initial victories and explorations for the player
        _simulateVictories(playerAddress, 0); // Simulate 0 victories
        _simulateExplorations(playerAddress, 0); // Simulate 0 explorations

        updateRanking();
    }

    function battleOpponent(address opponent) external {
        //require(players[msg.sender].tokenHolding > 0, "Not enough tokens");
        require(players[opponent].tokenHolding > 0, "Opponent lacks tokens");

        bool victory = (block.timestamp % 2 == 0); // Simple win condition
        if (victory) {
            players[opponent].victories++;
            players[opponent].experience += 10;
        }
        if (players[opponent].experience >= 10) {
            players[opponent].votingPower = true;
        }

        // Update rankings after the battle
        updateRanking();
    }

    function explore() external {
        require(players[msg.sender].tokenHolding > 0, "Not enough tokens");
        uint256 explorationReward = 50; // Reward for exploration
        players[msg.sender].explorationsCompleted++;
        players[msg.sender].tokenHolding += explorationReward; // Directly update token balance
        updateRanking();
    }

    function purchaseItem(uint256 itemCost) external {
        require(players[msg.sender].tokenHolding >= itemCost, "Not enough tokens");
        players[msg.sender].tokenHolding -= itemCost; // Deduct tokens for the item
        // Additional logic for purchasing items
    }

    function transferPlayerTokens(address recipient, uint256 amount) external {
        require(players[msg.sender].tokenHolding >= amount, "Not enough tokens");
        players[msg.sender].tokenHolding -= amount;
        players[recipient].tokenHolding += amount;
    }

    function viewLeaderboard() external view returns (address[] memory) {
        address[] memory sortedPlayers = new address[](playerList.length);
        for (uint256 i = 0; i < playerList.length; i++) {
            sortedPlayers[i] = playerList[i];
        }

        // Sort leaderboard by token holding (descending), and if tied, by victories
        for (uint256 i = 0; i < sortedPlayers.length; i++) {
            for (uint256 j = i + 1; j < sortedPlayers.length; j++) {
                address playerA = sortedPlayers[i];
                address playerB = sortedPlayers[j];
                if (
                    players[playerA].tokenHolding < players[playerB].tokenHolding ||
                    (players[playerA].tokenHolding == players[playerB].tokenHolding &&
                        players[playerA].victories < players[playerB].victories)
                ) {
                    address temp = sortedPlayers[i];
                    sortedPlayers[i] = sortedPlayers[j];
                    sortedPlayers[j] = temp;
                }
            }
        }
        return sortedPlayers;
    }

    function getPlayer(address playerAddress) external view returns (Player memory) {
        return players[playerAddress];
    }

    function _removePlayerData(address playerAddress) private {
        delete players[playerAddress];
        // Remove player address from playerList array
        for (uint256 i = 0; i < playerList.length; i++) {
            if (playerList[i] == playerAddress) {
                playerList[i] = playerList[playerList.length - 1];
                playerList.pop();
                break;
            }
        }
    }

    function _simulateVictories(address playerAddress, uint256 count) private {
        for (uint256 i = 0; i < count; i++) {
            players[playerAddress].victories++;
            players[playerAddress].experience += 10;
        }
        updateRanking();
    }

    function _simulateExplorations(address playerAddress, uint256 count) private {
        for (uint256 i = 0; i < count; i++) {
            players[playerAddress].explorationsCompleted++;
            uint256 explorationReward = 50; // Fixed reward
            players[playerAddress].tokenHolding += explorationReward;
        }
        updateRanking();
    }

    function updateRanking() private {
        // Bubble sort to maintain the leaderboard order
        for (uint256 i = 0; i < playerList.length; i++) {
            for (uint256 j = i + 1; j < playerList.length; j++) {
                if (
                    players[playerList[i]].tokenHolding < players[playerList[j]].tokenHolding ||
                    (players[playerList[i]].tokenHolding == players[playerList[j]].tokenHolding &&
                        players[playerList[i]].victories < players[playerList[j]].victories)
                ) {
                    address temp = playerList[i];
                    playerList[i] = playerList[j];
                    playerList[j] = temp;
                }
            }
        }
    }
}
