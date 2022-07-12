//SPDX-License-Identifier: MIT

//https://solidity-by-example.org/

pragma solidity ^0.8.8;
//Get funds from users
//Withdraw funds
//Set a minimum donation limit

import "./PriceConverter.sol";

error NotOwner();// introduced on version 0.8.4., it is more gas efficient than require
// use it with an if-else state, call like this: revert NotOwner(). This will revert
// transactions like require does for transfer, send, call, etc
// example in the onlyOwner modifier

contract FundMe{
    using PriceConverter for uint256;
    //This allows us to use PriceConverter library as if it is a method of uint256 class

    /*
    - constant : used for variables that are set once and never change. Using constant keyword saves gas. Customary to 
                 have these variables in all caps
    - immutable: used for variables which are declared first, then set to a value once and for all in a different line, like
                 the owner variable. Also saves gas. Variable names usually preceed with i_<var_name>
    */

    uint256 public constant MINIMUMUSD = 50 * 1e18; //$50 in solidity math needs 18 more zeros
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;
    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
        // Want to be able to set a minimum fund amount in USD

        // 1. How do we send ETH to this contract?
        // --> Every contract has its own wallet built-in

        //msg.value is a global variable for the value being sent
        //require(getConversionRate(msg.value) >= minimumUsd, "Sent less than min value");
        // 1e18wei = 1ETH (All calculations are done in terms of wei)
        require(msg.value.getConversionRate() >= MINIMUMUSD);
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

    function withdraw() public onlyOwner{//Modifier
        //only owner should be able to withdraw funds
        //require(msg.sender == owner, "Only owner is able to withdraw funds");

        //set addressToAmountFunded map to zero
        for(uint256 i=0; i<funders.length;i++){
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        // reset funders array
        funders = new address[](0);// this means funders is a brand new address array with 0 initial values in it
        // if we had passed (1) at the end of new address[] then it would mean new array has "1" initial value

        //ACTUALLY withdraw the fund
        /*
            There are 3 different ways to send ETH or other ERC20 crypto:
            - transfer
            - send
            - call
        */
        //https://solidity-by-example.org/sending-ether

        
        /*
            There are two types of addresses:
            - address
            - payable address -> used to send money to
        */
        //using transfer
        //using transfer, if payment fails, it will automatically revert back
        payable(msg.sender).transfer(address(this).balance);
        // "this" refers to the whole contract itself

        //using call --> returns bool on success/fail. If failure, we need to add a require
        // statement after call() to make sure revert happens. Just add a require with the
        // bool value returned from call()
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

        /*
            call() is a low level function that can be used to call any function in this contract without the
            need for an ABI. It returns two values, a boolean success value and an optional bytes array containing data
            returned by the function we called. We can also add some value in this call() statement. This would be the 
            value we add in "value" box in Remix IDE
        */
        //(bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");

        // the brackets("") at the end is where we pass info about the function we are calling. Since here we are not
        // actually calling a function, we pass ""
        // here we dont need to call a function so dataReturned is not needed
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // What if someone sends ether to this contract without calling fund()?
    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }

    //Modifiers are like middlewares in APIs
    modifier onlyOwner {
        //require(msg.sender == i_owner, "Only owner can withdraw funds");
        if (msg.sender != i_owner){
            revert NotOwner("Only owner can withdraw funds");
        }
        _;
    }
    // this modifier will basically take the function code and paste it in the
    // "_;". So now the modified function will have this require() statement 
    // at the top. Without the "_;" there will be no place for solidity to paste
    // the function code and the modifier won't work.
}