//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Panagram} from "../src/Panagram.sol";
import {HonkVerifier} from "../src/Verifier.sol";

contract PanagramTest is Test{

    HonkVerifier public verifier;
    Panagram public panagram;
    address user = makeAddr("user1");

    //Max size of the field 
    uint256 constant FIELD_MODULUS = 2 ** 256 - 1;

    //create the answer for "triangle"
    bytes32 ANSWER = bytes32(uint256(keccak256(abi.encodePacked("triangle"))) % FIELD_MODULUS);

    function setUp() public {
        //deploy the verifier
        verifier = new HonkVerifier();
        panagram = new Panagram(verifier);

        //start the rounds
        panagram.newRound(ANSWER);

        //make a guess

    }

    //this function to run the ts script to generate proof with ffi dependency
    function _getProof(bytes32 guess, bytes32 correctAnswer) internal returns (bytes memory _proof){
        uint256 constant NUM_ARGS = 5;
        
        string[] memory inputs = new string[](NUM_ARGS);
        inputs[0] = "npx";
        inputs[1] = "tsx";
        inputs[2] = "js-scripts/generate-proof.ts";
        inputs[3] = vm.toString(uint256(guess));
        inputs[4] = vm.toString(uint256(correctAnswer));

        bytes memory result = vm.ffi(inputs);
    }

    //test someone recieves NFT 0 when guess correctly first
    function testCorrectGuessPasses() public{
        vm.prank(user);
        panagram.makeGuess(proof); //provide valid proof here

    }

    //test someone gets NFT 1 is they guess correctly second

    //test if we can start a new round after time has passed

}
