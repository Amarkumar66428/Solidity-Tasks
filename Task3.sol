// Develop a smart contract that calculates and returns the sum of two numbers passed as parameters to a function.

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract calculator 
{
    function sum(uint a,uint b) public pure returns (uint)
    {
        return a + b;
    }
}