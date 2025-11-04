//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Panagram} from "../src/Panagram.sol";
import {HonkVerifier} from "../src/Verifier.sol";

contract PanagramTest is Test{

    HonkVerifier public verifier;
    Panagram public panagram;
    address user = makeAddr("user1");

    //Max size of the field 
    uint256 constant FIELD_MODULUS = 52435875175126190479447740508185965837690552500527637822603658699938581184513;

    //create the answer for "triangle" - reduced modulo field
    uint256 constant ANSWER_HASH = uint256(keccak256(abi.encodePacked("triangle")));
    uint256 constant ANSWER_VALUE = ANSWER_HASH % FIELD_MODULUS;
    
    // For debugging - simpler test value
    uint256 constant TEST_VALUE = 12345;

    function setUp() public {
        //deploy the verifier
        verifier = new HonkVerifier();
        panagram = new Panagram(verifier);

        //start the rounds - use test value for now
        panagram.newRound(bytes32(TEST_VALUE));
    }

    //this function to run the ts script to generate proof with ffi dependency
    function _getProof(bytes32 guess, bytes32 correctAnswer) internal returns (bytes memory _proof){
        uint256 NUM_ARGS = 5;
        
        string[] memory inputs = new string[](NUM_ARGS);
        inputs[0] = "npx";
        inputs[1] = "tsx";
        inputs[2] = "js-scripts/generateProof.ts";
        inputs[3] = vm.toString(uint256(guess));
        inputs[4] = vm.toString(uint256(correctAnswer));

        // vm.ffi returns the hex string as UTF-8 encoded bytes
        bytes memory hexStringBytes = vm.ffi(inputs);
        string memory hexString = string(hexStringBytes);
        
        // Convert hex string to bytes
        // The hex string includes "0x" prefix
        bytes memory hexBytes = bytes(hexString);
        uint256 hexLength = hexBytes.length;
        
        // Remove "0x" prefix if present
        uint256 startIdx = 0;
        if (hexLength >= 2 && hexBytes[0] == '0' && hexBytes[1] == 'x') {
            startIdx = 2;
        }
        
        // Calculate output length (each pair of hex chars = 1 byte)
        uint256 dataLength = (hexLength - startIdx) / 2;
        bytes memory data = new bytes(dataLength);
        
        for (uint256 i = 0; i < dataLength; i++) {
            uint8 hi = hexCharToUint(hexBytes[startIdx + i * 2]);
            uint8 lo = hexCharToUint(hexBytes[startIdx + i * 2 + 1]);
            data[i] = bytes1(hi * 16 + lo);
        }
        
        _proof = data;
        console.log("Proof length:", _proof.length);
    }
    
    function hexCharToUint(bytes1 c) internal pure returns (uint8) {
        bytes1 char = c;
        if (char >= bytes1('0') && char <= bytes1('9')) {
            return uint8(char) - uint8(bytes1('0'));
        } else if (char >= bytes1('a') && char <= bytes1('f')) {
            return uint8(char) - uint8(bytes1('a')) + 10;
        } else if (char >= bytes1('A') && char <= bytes1('F')) {
            return uint8(char) - uint8(bytes1('A')) + 10;
        }
        return 0;
    }

    //test someone recieves NFT 0 when guess correctly first
    function testCorrectGuessPasses() public {
        vm.prank(user);
        // Use test values that are definitely within field
        bytes memory proof = _getProof(bytes32(TEST_VALUE), bytes32(TEST_VALUE));
        panagram.makeGuess(proof);
    }

    //test someone gets NFT 1 is they guess correctly second

    //test if we can start a new round after time has passed

}
