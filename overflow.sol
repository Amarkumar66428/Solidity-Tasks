// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract local 
{
    uint8 public money = 255;
    function setter() public
    {
        money += 1;
    }      
}        