//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Panagram} from "../src/Panagram.sol";
import {HonkVerifier} from "../src/Verifier.sol";

contract PanagramTest is Test{

    HonkVerifier public verifier;
    Panagram public panagram;

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

    //test someone recieves NFT 0 when guess correctly first


    //test someone gets NFT 1 is they guess correctly second

    //test if we can start a new round after time has passed

}
