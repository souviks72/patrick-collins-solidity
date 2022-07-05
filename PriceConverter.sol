// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";//not a syntax error


library PriceConverter{
    /*
    Gets price of ETH by calling a ChainLink smartcontract
    */
    function getPrice() internal view returns(uint256){
        //ABI 
        // Adrress 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int price,,,) = priceFeed.latestRoundData();// returns multiple values but we need only price
        //ETH in terms of USD
        // 3000.00000000
        /*
        Solidity does not work with decimals. So the actual value returned by the AggregatorV3 is 3*10^11.However,
        the Aggregator also has a "decimal()" function that returns the number of decimals in the price(USD) it returns. It returns 8.
        To work with that value in solidity, we need it to have the same number of decimal places as 1ETH in terms of Wei(10^(-18))
        So we multiply that with 10^10 so it has same decimals(but, we cannot explicitly write the decimal point. So price of 1ETH in USD
        will be 3000*10^(18), actual price being $3000). 
        */
        return uint256(price * 1e10);
        //we need this in same format as wei (1e18)
        // msg.value is sent in terms of wei and always is of magnitude 18
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice*ethAmount)/1e18;
        /*
        - In Solidity, always multiply/add before u divide
        - since both ethPrice and ethAmount have 18 decimal points, if we multiply
          them, they will have 36 decimals
        */
        return ethAmountInUsd;
    }


    function getVersion() internal view returns (uint256){
        return AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e).getVersion(); 
    }
}