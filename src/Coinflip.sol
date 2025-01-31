// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error SeedTooShort();

/// @title Coinflip 10 in a Row
/// @author Tianchan Dong
/// @notice Contract used as part of the course Solidity and Smart Contract development
contract Coinflip is Ownable {
    
    string public seed;

    constructor() Ownable(msg.sender) {
        seed = "It is a good practice to rotate seeds often in gambling";
    }

    /// @notice Checks user input against contract generated guesses
    /// @param Guesses is a fixed array of 10 elements which holds the user's guesses. The guesses are either 1 or 0 for heads or tails
    /// @return true if user correctly guesses each flip correctly or false otherwise
    function userInput(uint8[10] calldata Guesses) external view returns (bool) {
        uint8[10] memory generatedFlips = getFlips();

        for (uint i = 0; i < 10; i++) {
            if (Guesses[i] != generatedFlips[i]) {
                return false;
            }
        }
        return true;
    }

    /// @notice allows the owner of the contract to change the seed to a new one
    /// @param NewSeed is a string which represents the new seed
    function seedRotation(string memory NewSeed) public onlyOwner {
        bytes memory seedBytes = bytes(NewSeed);
        uint seedLength = seedBytes.length;

        if (seedLength < 10) {
            revert SeedTooShort();
        }
        
        seed = NewSeed;
    }

    // -------------------- helper functions -------------------- //
    /// @notice This function generates 10 random flips by hashing characters of the seed
    /// @return a fixed 10 element array of type uint8 with only 1 or 0 as its elements
    function getFlips() public view returns (uint8[10] memory) {
        bytes memory seedBytes = bytes(seed);
        uint seedLength = seedBytes.length;
        uint8[10] memory flips;

        uint interval = seedLength / 10;

        for (uint i = 0; i < 10; i++) {
            uint randomNum = uint(keccak256(abi.encode(seedBytes[i * interval], block.timestamp)));
            flips[i] = (randomNum % 2 == 0) ? 1 : 0;
        }

        return flips;
    }
}
