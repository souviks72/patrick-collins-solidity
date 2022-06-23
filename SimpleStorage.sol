// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
//pragma solidity ^0.8.7; ^symbol means any version of 0.8 from 0.8.7 onwards

contract SimpleStorage{
    //boolean, uint, int, address, bytes, string
    //In SOlidity there is no concept of null. So if we just declare any
    //variable, it will be set to 0 by default or equivalent value of
    //that data type. Eg: string would be "", boolean would be false, etc
    uint256 public favouriteNumber;
    //public variables automatically have a getter provided by solidity

    function store(uint256 _favouriteNumber) public {
        favouriteNumber = _favouriteNumber;
    }

    //view, pure
    /*
    - pure functions have don't read and dont modify state variables
    - view functions only read but not modify state variables
    - view and pure functions don't require any gas, unless a gas spending
      function calls them.
    */
    function retrieve() public view returns(uint256){
        return favouriteNumber;
    }
}
