// Create a smart contract that checks whether a given string is a palindrome or not.

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Check_Palindrome
{  
    function check(string memory b) public pure returns(string memory)
    {
      bytes memory a = bytes(b);
      uint len = a.length;

      for(uint i=0;i< len / 2 ;i++)
      {
          if(a[i] == a[len -1 -i])
          {
              return "Palindrome";
          }
      }
      return "Not Palindrome";
    }
}