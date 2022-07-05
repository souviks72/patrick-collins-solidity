// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
//pragma solidity ^0.8.8; ^symbol means any version of 0.8.x from 0.8.8 and above
//we can also specify a range, or exact version

contract SimpleStorage{
    //boolean, uint, int, address, bytes, string
    //In Solidity there is no concept of null. So if we just declare any
    //variable, it will be set to 0 by default or equivalent value of
    //that data type. Eg: string would be "", boolean would be false, etc
    uint256 public favouriteNumber;
    //public variables automatically have a getter provided by solidity

    //-----------STRUCT--------------------
    struct People{
        uint256 favouriteNumber;
        string name;
    }

    People public souvik = People({favouriteNumber: 13, name: "Souvik"});

    //------------ARRAYS---MAPPINGS-------------
    People[] public peopleList;
    mapping(string => uint256) public nameToFavouriteNumber;

    function store(uint256 _favouriteNumber) public virtual{
        favouriteNumber = _favouriteNumber;
    }

    //view, pure
    /*
    - pure functions don't read and dont modify state variables
    - view functions only read but not modify state variables
    - view and pure functions don't require any gas, unless a gas spending
      function calls them.
    */
    function retrieve() public view returns(uint256){
        return favouriteNumber;
    }

    //calldata, memory, storage
    /*
    - calldata is immutable, local storage(RAM), no gas
    - memory is mutable local storage, no gas
    - storage is mutable, blockchain storage, costs gas,eg: state variables
     */
    function addPeople(uint256 _favouriteNumber, string memory _name) public {
        People memory newPerson = People({favouriteNumber: _favouriteNumber, name: _name});
        peopleList.push(newPerson);
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}
