// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract State
{
    uint public age; //state variable
    uint public number; //state variable
     
    // constructor()
    //  {
    //     age=10;
    //  }
    function setAge() public
    {
        age=10;
    }
    function setNumber() public
    {
        number +=100;
    }
}