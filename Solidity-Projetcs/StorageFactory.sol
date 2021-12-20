// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// Importing our previous program to access its functions
import "./SimpleStorage.sol";

// Creating Contract for deploying the SimpleStorage contract through this contract
contract StorageFactory {

    // Defining an array to keep track of all the SimpleStorage Contracts
    SimpleStorage[] public simpleStorageArray;

    // defining a function for creating the SimpleStorage contract with a single call
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    // Interacting with the deployed contracts
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // Two things needed for interacting with a contract
        // Address
        // ABI = Application Binary Interface

        // Getting the address for interaction with the contract using its index
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        // Using store function from SimpleStorage to save favouriteNumber
        simpleStorage.store(_simpleStorageNumber);

        simpleStorage.retrieve();
    }

    // Creating a retrieve function to see our favNumber for each contract
    function sfGet(uint256 _simpleStorageIndex) view public returns(uint256) {
        // Getting the address of the contract
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));

        // Retrieving the value
        return simpleStorage.retrieve();
    }
}
