//SPX-License-identifier: MIT
pragma solidity ^0.8.26;

//importing ERC1155 standard from openzeppelin for creating multi token contract
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Verifier} from "./Verifier.sol";

contract Panagram is ERC1155 {
    IVerifier public constant verifier;

    constructor(
        IVerifier _verifier
    )
        ERC1155(
            "ipfs/bafybeibfoq4c7u7v2beaw53cbbt77rgfrr7tcv3subriq6ufgxxfo5d6e4/{id}.json"
        )
    {
        verifier = _verifier;
    }

    //contract uri function can be created - compatible with opensea

    //function to create a new round

    //function to allow user to submit a guess

    
}
