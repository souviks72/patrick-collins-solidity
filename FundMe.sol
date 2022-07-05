//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
//Get funds from users
//Withdraw funds
//Set a minimum donation limit

import "./PriceConverter.sol";

contract FundMe{
    using PriceConverter for uint256;
    //This allows us to use PriceConverter library as if it is a method of uint256 class

    uint256 public minimumUsd = 50 * 1e18; //$50 in solidity math needs 18 more zeros
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable{
        // Want to be able to set a minimum fund amount in USD

        // 1. How do we send ETH to this contract?
        // --> Every contract has its own wallet built-in

        //msg.value is a global variable for the value being sent
        //require(getConversionRate(msg.value) >= minimumUsd, "Sent less than min value");
        // 1e18wei = 1ETH (All calculations are done in terms of wei)
        require(msg.value.getConversionRate() >= minimumUsd);
        //using the library and "for" keyword, getConversionRate is now a function of uint256(here msg.value) itself
        // So we can call getConversion() ON msg.value and msg.value WILL BE PASSED AS THE FIRST argument to getConversionRate always by default
        //hence no need to pass it. If there were more args in getConversionRate() then we will need to pass them explicitly
        /*
         However, we really want to set min value in $ terms (minimumUsd). So we need to
         access data outside the blockchain, something like ChainLink Oracle
        */
        // What is reverting?
        // Undo any action before, and send remaining gas back
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value; 
        //msg.sender is a global value for the wallet address calling a function in a contract
    }    
}