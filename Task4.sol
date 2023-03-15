// Write a contract that generates a random number between 1 and 100 and returns it to the user.

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract randomNumber
{
    function generate() public view returns (uint) {
    uint number = uint(keccak256(abi.encodePacked(block.timestamp)));
    return (number % 100);
}
}