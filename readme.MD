# ZK Panagram - Zero Knowledge Proof-Based Word Guessing Game

## Overview

A smart contract-based guessing game where players submit proofs they know the answer without revealing it. Uses Noir for generating zero-knowledge proofs and Solidity smart contracts for onchain verification and NFT rewards.

## Project Structure

- **Smart Contracts** (`contracts/src/`)
  - `Panagram.sol` - Main game contract managing rounds and guesses
  - `Verifier.sol` - Aztec Honk proof verifier (auto-generated)

- **Noir Circuit** (`circuits/src/main.nr`)
  - Hash equality verification without revealing inputs
  - Proves: `guess_hash == answer_hash`

- **Proof Generation** (`contracts/js-scripts/generateProof.ts`)
  - TypeScript/Node.js script for generating Noir proofs
  - Uses Noir JS bindings + Aztec UltraHonk backend
  - Called via Foundry's `vm.ffi()` during tests

## Setup Instructions

### Prerequisites
- Node.js 18+
- Rust (for Noir compiler)
- Foundry (`forge`, `cast`)

### Installation

```bash
# Install Nargo (Noir compiler)
noirup -v 1.0.0-beta.14

# Install Node dependencies
npm install

# Install Foundry dependencies
cd contracts && forge install

# Compile Noir circuit
cd ../circuits && nargo compile --force

# Return to contracts directory
cd ../contracts
```

### Running Tests

```bash
# Run all tests with verbose output
forge test -vvvv

# Run specific test
forge test -k testCorrectGuessPasses -vvvv
```

## Current Status

✅ **Completed:**
- Smart contract compiles without errors
- ERC-1155 NFT infrastructure for rewards
- Noir circuit for hash comparison
- Proof generation script working
- Test framework integrated with FFI for proof generation
- Version compatibility achieved (Noir beta.14)

⚠️ **In Progress:**
- Honk proof verification with correct serialization format
- Current proof size: 4512 bytes (expected: 16224 bytes)
- Requires investigation into Honk proof serialization

## Key Technologies

- **Solidity** ^0.8.24 - Smart contracts
- **Noir** 1.0.0-beta.14 - Zero-knowledge circuits
- **Aztec Honk** - UltraHonk backend for proof generation
- **OpenZeppelin** v5.3.0 - ERC-1155 standard
- **Foundry** - Solidity development and testing
- **ethers.js** v6.15.0 - ABI encoding/decoding

## Game Logic

1. **Round Setup**: Owner creates a round with a secret answer hash
2. **Player Guess**: Player submits a guess and generates a zero-knowledge proof
3. **Verification**: Contract verifies proof onchain via Honk verifier
4. **Reward**: Winner gets NFT token ID 0, runner-up gets token ID 1

##  Architecture

```
Player submits (guess, proof)
        ↓
Foundry FFI calls generateProof.ts
        ↓
Noir circuit executes: proves guess_hash == answer_hash
        ↓
UltraHonk backend generates proof
        ↓
Proof returned to test/contract
        ↓
Verifier.sol validates proof onchain
        ↓
NFT minted to winner
```

## Known Issues & TODO

1. **Proof Size Mismatch**: The proof generated is 4512 bytes but verifier expects 16224 bytes (507 * 32)
   - Possible solutions:
     - Different serialization format required
     - Padding/formatting of proof bytes
     - Different proof compression settings in UltraHonk backend

2. **Future Enhancements**:
   - Implement round timing validation (minimum 3-hour duration)
   - Add duplicate guess prevention
   - Deploy to testnet
   - Frontend UI for guess submission
   - Production HTTPS deployment

## Files Modified/Created This Session

- `src/Panagram.sol` - Fixed imports, added game logic
- `test/Panagram.t.sol` - Created test suite with FFI proof generation
- `js-scripts/generateProof.ts` - Proof generation script
- `contracts/package.json` - Node dependencies configuration
- `foundry.toml` - Foundry configuration with remappings
- README - This file