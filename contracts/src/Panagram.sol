//SPX-License-identifier: MIT
pragma solidity ^0.8.24;

//importing ERC1155 standard from openzeppelin for creating multi token contract
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {IVerifier} from "./Verifier.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Panagram is ERC1155, Ownable {
    IVerifier public verifier;

    //state variables
    uint256 public constant MIN_DURATION = 10800; //3 hours
    uint256 public s_roundStartTime = 0;
    address public s_currentRoundWinner;
    uint256 public s_currentRound = 0;
    bytes32 public s_answer;
    mapping(address => uint256) public s_LastCorrectGuessRound;

    //events
    event Panagram__VerifierUpdated(IVerifier newVerifier);
    event Panagram__NewRoundStarted(bytes32 answer);

    //error in the contract
    error Panagram__MinTimeNotPassed(uint256 required, uint256 current);
    error Panagram__NoWinnerYet();
    error Panagram__FirstPanagramNotSet();
    error Panagram__AlreadyGuessedCorrectly(uint256 round, address user);
    error Panagram__InvalidProof();
    event Panagram__WinnerCrowned(address indexed winner, uint256 round);
    event Panagram__RunnerUpCrowned(address indexed runnerUp, uint256 indexed round);

    constructor(
        IVerifier _verifier
    )
        ERC1155(
            "ipfs/bafybeibfoq4c7u7v2beaw53cbbt77rgfrr7tcv3subriq6ufgxxfo5d6e4/{id}.json"
        )
        Ownable(msg.sender)
    {
        verifier = _verifier;
    }

    //contract uri function can be created - compatible with opensea

    //function to create a new round
    function newRound(bytes32 _answer) external onlyOwner {
        //if the round start time is 0, then its the first round
        if (s_roundStartTime == 0) {
            s_roundStartTime = block.timestamp;
            s_answer = _answer;
        }
        //if the round start time is not 0, then its not the first round
        else {
            //check if the minimum duration has passed
            if (s_roundStartTime + MIN_DURATION > block.timestamp) {
                revert Panagram__MinTimeNotPassed(
                    MIN_DURATION,
                    block.timestamp - s_roundStartTime
                );
            }
            //check no one has guessed the answer yet
            if (s_currentRoundWinner == address(0)) {
                revert Panagram__NoWinnerYet();
            }

            //reset the round and timings
            s_roundStartTime = block.timestamp;
            s_currentRoundWinner = address(0);
            s_answer = _answer;
        }

        s_currentRound++;
        emit Panagram__NewRoundStarted(_answer);
    }

    //function to allow user to submit a guess
    function makeGuess(bytes memory proof) external returns (bool) {
        //check if first round has started
        if (s_currentRound == 0) {
            revert Panagram__FirstPanagramNotSet();
        }

        //check if users has already guessed the answer
        if (s_LastCorrectGuessRound[msg.sender] == s_currentRound) {
            revert Panagram__AlreadyGuessedCorrectly(
                s_currentRound,
                msg.sender
            );
        }

        //chek the proof and verify it with verify contract
        bytes32[] memory publicInputs = new bytes32[](1);
        publicInputs[0] = s_answer;
        bool proofResult = verifier.verify(proof, publicInputs);

        //revert if incorrect
        if (!proofResult) {
            revert Panagram__InvalidProof();
        }

        s_LastCorrectGuessRound[msg.sender] = s_currentRound;
        //if correct check they are first, if they are then mint the nft with id = 0
        if (s_currentRoundWinner == address(0)) {
            s_currentRoundWinner = msg.sender;
            _mint(msg.sender, 0, 1, "");
            emit Panagram__WinnerCrowned(msg.sender, s_currentRound);
        } else {
            //if they are correct but not first, then mint NFT id = 1
            _mint(msg.sender, 1, 1, "");
            emit Panagram__RunnerUpCrowned(msg.sender, s_currentRound);
        }
        return proofResult;
    }

    //function to set a new verifier only accessed by owner
    function setVerifier(IVerifier _verifier) external onlyOwner {
        verifier = _verifier;
        emit Panagram__VerifierUpdated(_verifier);
    }
}
