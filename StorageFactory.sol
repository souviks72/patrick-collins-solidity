//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./SimpleStorage.sol";

contract StorageFactory{
    SimpleStorage[] public simpleStorageArray;

    //Creating a smart contract
    function createSimpleStorageContract() public{
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    //Interacting with other smart contracts, here SimpleStorage
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        /*
            To interact with another smart contract we need two things:
            - address
            - ABI --> Application Binary Interface
        */
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
} 