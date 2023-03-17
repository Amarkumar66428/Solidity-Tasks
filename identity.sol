// SPDX-License-identifier: GPL-3.0
pragma solidity >= 0.5.0 < 0.9.0;

contract identity
{
    string _name;
    uint age;

    constructor() public
    {
        _name = "Monu";
        age = 17;
    }

    function getName() view public returns(string memory)
    {
        return _name;
    }
    function getAge() view public returns(uint)
    {
        return age;
    }
     function setAge() public
     {
         age += 1;
     }


function check(string memory str) public pure returns(string memory)
    {
      bytes memory a = bytes(str);
      uint len = a.length;

      for(uint i=0;i< len / 2 ;i++)
      {

          if(a[i] != a[len -1 -i])
          {
              return "Not Palindrome";
          }
      }
      return "Palindrome";
    }
}