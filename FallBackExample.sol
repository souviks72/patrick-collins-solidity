//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract FallBackExample{
    uint256 public result;

    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}

/*
receive() and fallback are special functions in solidity like the constructor
You will need to call them with the external and payable function modifiers

RECEIVE--------------
receive is called when we send ether directly to a smart contract without calling
a function, i.e. calldata(msg.data) is empty

FALLBACK-------------
fallback is a function that does not take any arguments and does not return anything.

It is executed either when

a function that does not exist is called or
Ether is sent directly to a contract but receive() does not exist or msg.data is not empty
fallback has a 2300 gas limit when called by transfer or send.
*/

// Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()