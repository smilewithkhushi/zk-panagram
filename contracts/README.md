# ZK Panagram

A zero-knowledge based panagram guessing game smart contract built with ERC-1155 NFT functionality.

## Overview

Panagram is a competitive guessing game where players submit answers in rounds. Each round is managed by the contract owner, and winners are rewarded with NFTs based on their placement. The contract uses zero-knowledge proofs for verifying correct answers while preserving privacy.

## Game Mechanics

### Rounds

- Each panagram answer represents one **round**
- Rounds have a **minimum duration** before they can be closed
- A round must have at least one winner before the next round can begin

### Access Control

- Only the **contract owner** can initiate new rounds
- Players can submit guesses during an active round

### Guess Verification

- Player guesses are verified through an external **Verifier contract**
- Verification uses zero-knowledge proofs to ensure correctness without revealing sensitive information

## Rewards (ERC-1155 NFT)

Winners are minted NFTs based on their placement:

- **Token ID 0**: First correct guess (Winner) - minted to the first player to answer correctly in a round
- **Token ID 1**: Correct guess (Runner-up) - minted to subsequent players who answer correctly in the same round

## Setup

### Prerequisites

- [Foundry](https://book.getfoundry.sh/) installed on your system

### Installation

Initialize the Foundry project and install dependencies:

```bash
foundry init
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

**Dependencies:**
- OpenZeppelin Contracts v5.3.0

### Building

Compile the smart contracts:

```bash
forge build
```

### Testing

Run the test suite:

```bash
forge test
```

## Contract Files

- `Panagram.sol` - Main game contract with ERC-1155 functionality
- `Verifier.sol` - Zero-knowledge proof verifier contract

