// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Array
{
    bytes public b1 = 'abc';
    
    function pushElement() public
    {
        b1.push('d');
    }
    // function pushElement(uint item) public
    // {
    //     b1.push(item);
    // }
    function getElement(uint i) public view returns(bytes1)
    {
        return b1[i];
    }
    function getlength() public view returns(uint)
    {
       return b1.length;
    }
}
