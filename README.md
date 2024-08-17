# DeFi Kingdom Clone on Avalanche

## Overview

This project is a decentralized gaming platform built on the Avalanche blockchain, inspired by the concept of DeFi Kingdoms. The game allows players to explore, purchase items, and engage in battles using digital assets. Players can earn rewards in the form of custom tokens, which can be used within the game. The platform is designed to leverage the benefits of blockchain technology, providing a transparent and decentralized gaming experience.

## Features

- **Custom EVM Subnet**: The game operates on a custom EVM subnet within the Avalanche network.
- **In-Game Currency**: Players use a custom token (`Lalit`, symbol `LOL`) for transactions within the game.
- **Player Interaction**: Players can register, battle, explore, purchase items, and transfer tokens.
- **Leaderboard**: A dynamic leaderboard ranks players based on their token holdings and battle victories.

## Getting Started

### Prerequisites

- **Avalanche CLI**: Required for creating and managing the custom EVM subnet.
- **Metamask**: A web wallet used to interact with the Avalanche network and the custom EVM subnet.
- **Remix IDE**: An online Solidity editor for writing, deploying, and testing smart contracts.

### Step-by-Step Guide

#### 1. Deploying Your EVM Subnet

Use the Avalanche CLI to create and configure a custom EVM subnet. This subnet will serve as the environment for deploying the game's smart contracts.

#### 2. Add Your Subnet to Metamask

Add your custom EVM subnet to Metamask to enable communication with the subnet. This step is crucial for interacting with smart contracts from within your wallet.

#### 3. Set Metamask to Your Custom Subnet

Switch the network in Metamask to your custom EVM subnet. This ensures that all transactions and interactions occur on the correct network.

#### 4. Connect Remix to Metamask

Connect the Remix IDE to your Metamask wallet using the Injected Provider option. This allows you to deploy smart contracts directly from Remix.

#### 5. Deploy the GameToken Contract

Use Remix to compile and deploy the `GameToken.sol` contract on your custom EVM subnet. This contract will create the in-game currency, `Lalit` (symbol `LOL`).

#### 6. Enable Game Mechanics with Smart Contracts

Copy and deploy the `MYVault.sol` contract using Remix. This contract handles player management, battles, exploration, and token transactions within the game.

#### 7. Test Your Application

After deploying the contracts, test your application by interacting with the various game features, such as registering players, initiating battles, and exploring.

## Game Mechanics

### Token Management

- **Depositing Tokens**: Players can deposit tokens into the game to earn shares representing their contribution to the overall token pool.
- **Withdrawing Tokens**: Players can withdraw their tokens based on the shares they own, reflecting their share of the game's total token balance.

### Player Management

Each player is represented by a structure that includes their token balance, experience points, achievements, victories, explorations completed, voting power, level, and name.

### Core Game Features

- **Register Player**: Players can register by providing a name and starting attributes, which initializes their game profile.
- **Battle**: Engage in battles with other players to gain experience points and possibly voting rights.
- **Explore**: Players can explore the game world to earn rewards such as tokens and experience points.
- **Purchase Items**: Spend tokens on in-game items and upgrades to enhance gameplay.

### Leaderboard

The contract maintains a leaderboard that ranks players based on their token holdings and battle victories. The leaderboard is updated dynamically as players interact with the game.

## License

This project is licensed under the MIT License. For more details, see the LICENSE.md file.

---

**Author**: Lalit Kumar
