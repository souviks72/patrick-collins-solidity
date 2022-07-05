//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./SimpleStorage.sol";

/*I N H E R I T A N C E
- Inherit another contract using the "is" keyword
- Use "virtual" keyword in parent class function to make it overrride-able
- Use "override" keyword in the child class function
*/

contract ExtraStorage is SimpleStorage{
    function store(uint256 _favouriteNumber) public override{
        favouriteNumber = _favouriteNumber + 5;
    }
}